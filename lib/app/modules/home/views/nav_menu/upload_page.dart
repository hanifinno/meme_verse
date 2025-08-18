import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';

class UploadMemePage extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Meme")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return controller.pickedFile.value != null
                  ? Image.file(controller.pickedFile.value!, height: 200)
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Text("No image selected")),
                    );
            }),
            const SizedBox(height: 16),
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: "Meme Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: ()async{
                 await   controller.pickImage();
                 
                  },
                  child: const Text("Pick Image"),
                ),
                const SizedBox(width: 16),
                Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: controller.uploadMeme,
                          child: const Text("Upload"),
                        );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
