const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
// Import the new, recommended library for Gemini
const cors = require("cors")({origin: true});
const Busboy = require("busboy");
const {VertexAI} = require("@google-cloud/vertexai");

admin.initializeApp();

const project = "memeverse-2bc9f";
const location = "us-central1";
// Switch to the Gemini 1.0 Pro Vision model, which can process images
const model = "gemini-2.5-pro";

exports.generateMemeCaption = onRequest(
  {
    serviceAccount: "meme-caption-ai@memeverse-2bc9f.iam.gserviceaccount.com",
    memory: "512MiB",
    // Increase timeout as fetching an image and calling the model can take time
    timeoutSeconds: 120,
  },
  (req, res) => {
    // Handle CORS for cross-origin requests from your app.
    cors(req, res, async () => {
      if (req.method !== "POST") {
        return res.status(405).json({error: "Method Not Allowed"});
      }

      try {
        // Wait for the multipart form to be fully parsed.
        const files = await new Promise((resolve, reject) => {
          const busboy = Busboy({headers: req.headers});
          const files = [];

          busboy.on("error", (err) => {
            reject(err);
          });

          busboy.on("file", (fieldname, file, {filename, mimeType}) => {
            console.log(`Processing file: ${filename} (${mimeType})`);
            const chunks = [];
            file.on("data", (chunk) => chunks.push(chunk));
            file.on("end", () => {
              files.push({
                fieldname,
                buffer: Buffer.concat(chunks),
                mimeType,
              });
            });
          });

          busboy.on("close", () => {
            resolve(files);
          });

          busboy.end(req.rawBody);
        });

        if (files.length === 0) {
          return res.status(400).json({error: "No image file uploaded."});
        }

        const imageFile = files[0];
        const imageBase64 = imageFile.buffer.toString("base64");

        const vertex_ai = new VertexAI({project: project, location: location});
        const generativeVisionModel = vertex_ai.getGenerativeModel({model});

        const textPart = {
          text: "Generate 3 funny, short meme captions for this image. Each caption should be on a new line.",
        };

        const imagePart = {
          inlineData: {
            mimeType: imageFile.mimeType,
            data: imageBase64,
          },
        };

        const requestPayload = {
          contents: [{role: "user", parts: [textPart, imagePart]}],
        };

        const result = await generativeVisionModel.generateContent(requestPayload);
        const content = result.response.candidates[0].content.parts[0].text;

        const captions = content
            .split("\n")
            .map((c) => c.replace(/^- /, "").trim())
            .filter(Boolean);

        res.status(200).json({captions});
      } catch (err) {
        console.error("Function Error:", err);
        if (!res.headersSent) {
          // The error from the promise will be caught here
          res.status(500).json({error: `Error processing request: ${err.message}`});
        }
      }
    });
  },
);
