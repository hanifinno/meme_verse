// Meme Caption Generator Edge Function
// Required environment variable: GEMINI_API_KEY
/**
 * Fetch an image and convert it to base64
 * @param {string} imageUrl - URL of the image to fetch
 * @returns {Promise<string>} Base64 encoded image
 */ async function fetchImageAsBase64(imageUrl) {
  try {
    const imageResponse = await fetch(imageUrl);
    if (!imageResponse.ok) {
      console.error(`Failed to fetch image: ${imageResponse.statusText}`);
      throw new Error(`Failed to fetch image: ${imageResponse.statusText}`);
    }
    // Handle different image types
    const contentType = imageResponse.headers.get('content-type') || '';
    const allowedTypes = [
      'image/jpeg',
      'image/png',
      'image/gif',
      'image/webp'
    ];
    if (!allowedTypes.includes(contentType)) {
      throw new Error(`Unsupported image type: ${contentType}`);
    }
    const arrayBuffer = await imageResponse.arrayBuffer();
    const base64 = btoa(new Uint8Array(arrayBuffer).reduce((data, byte)=>data + String.fromCharCode(byte), ""));
    return base64;
  } catch (error) {
    console.error(`Error in fetchImageAsBase64: ${error.message}`);
    throw error;
  }
}
/**
 * Generate meme captions using Gemini API
 * @param {string} imageUrl - URL of the image to generate captions for
 * @returns {Promise<string[]>} Array of meme captions
 */ async function generateCaptions(imageUrl) {
  const geminiApiKey = Deno.env.get("GEMINI_API_KEY");
  if (!geminiApiKey) {
    console.error("Gemini API key not configured");
    throw new Error("Gemini API key not configured");
  }
  const geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent";
  try {
    console.log(`Fetching image from: ${imageUrl}`);
    const response = await fetch(geminiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": geminiApiKey
      },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              {
                text: "Generate 3 hilarious meme captions for this image. " + "Make them witty, pop-culture relevant, and suitable for social media. " + "Number each caption and keep them under 100 characters."
              },
              {
                inlineData: {
                  mimeType: "image/jpeg",
                  data: await fetchImageAsBase64(imageUrl)
                }
              }
            ]
          }
        ],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 256
        }
      })
    });
    if (!response.ok) {
      const errorText = await response.text();
      console.error(`Gemini API request failed: ${response.statusText}`);
      console.error(`Error details: ${errorText}`);
      throw new Error(`Gemini API request failed: ${response.statusText}`);
    }
    const data = await response.json();
    console.log("Gemini API response:", JSON.stringify(data, null, 2));
    const rawCaptions = data.candidates?.[0]?.content?.parts?.[0]?.text || "";
    const captions = rawCaptions.split("\n").filter((caption)=>caption.trim() !== "").slice(0, 3);
    // Fallback if no captions generated
    return captions.length > 0 ? captions : [
      "Meme Caption 1",
      "Meme Caption 2",
      "Meme Caption 3"
    ];
  } catch (error) {
    console.error(`Error in generateCaptions: ${error.message}`);
    throw error;
  }
}
// Main Edge Function handler
Deno.serve(async (req)=>{
  try {
    // Validate request method
    if (req.method !== "POST") {
      return new Response("Method Not Allowed", {
        status: 405,
        headers: {
          "Allow": "POST"
        }
      });
    }
    // Check content type
    const contentType = req.headers.get("content-type") || "";
    const isMultipart = contentType.includes("multipart/form-data");
    const isJson = contentType.includes("application/json");
    if (!isMultipart && !isJson) {
      return new Response("Unsupported Media Type", {
        status: 415,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    // Extract image URL
    let imageUrl = null;
    if (isMultipart) {
      const formData = await req.formData();
      imageUrl = formData.get("imageUrl");
    } else if (isJson) {
      const body = await req.json();
      imageUrl = body.imageUrl;
    }
    // Validate image URL
    if (!imageUrl) {
      return new Response(JSON.stringify({
        error: "imageUrl is required",
        message: "Please provide an image URL in the request"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    // Validate URL format
    try {
      new URL(imageUrl);
    } catch  {
      return new Response(JSON.stringify({
        error: "Invalid URL",
        message: "The provided imageUrl is not a valid URL"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    // Generate captions
    const captions = await generateCaptions(imageUrl);
    console.log("Generated captions:", captions);
    // Return successful response
    return new Response(JSON.stringify({
      captions,
      source: imageUrl
    }), {
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-store"
      },
      status: 200
    });
  } catch (err) {
    // Catch-all error handler
    console.error(`Unhandled error: ${err.message}`);
    console.error(err.stack);
    return new Response(JSON.stringify({
      error: "Internal Server Error",
      message: err.message
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
});
