const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const { PredictionServiceClient } = require("@google-cloud/aiplatform").v1;

admin.initializeApp();

const project = "memeverse-2bc9f";
const location = "us-central1";
const publisher = "google";
const model = "text-bison";

exports.generateMemeCaption = onRequest(
  {
    serviceAccount: "meme-caption-ai@memeverse-2bc9f.iam.gserviceaccount.com",
    memory: "512MiB",
  },
  async (req, res) => {
  try {
    const client = new PredictionServiceClient({
      apiEndpoint: 'us-central1-aiplatform.googleapis.com',
    });
    const { imageUrl } = req.body;

    if (!imageUrl) return res.status(400).json({ error: "Missing imageUrl" });

    const promptText = `Generate 3 funny meme captions for this image URL: ${imageUrl}`;

    // The AI Platform service expects instances to be in a specific Protobuf JSON format.
    const instance = {
      structValue: {
        fields: {
          prompt: {
            stringValue: promptText,
          },
        },
      },
    };

    const endpoint = client.projectLocationPublisherModelPath(project, location, publisher, model);
    const request = {
      endpoint: endpoint,
      instances: [instance],
    };

    const [response] = await client.predict(request);

    const prediction = response.predictions[0];
    const captions = prediction.structValue.fields.content.stringValue
      .split("\n")
      .map((c) => c.trim())
      .filter(Boolean);

    res.status(200).json({ captions });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});
