import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'client_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/id_photo_picker.dart';

class ClientView extends GetView<ClientController> {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.showAddDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.clients.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final clients = controller.filteredClients;

              if (clients.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Aucun client'
                            : 'Aucun résultat',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (controller.searchQuery.value.isEmpty)
                        TextButton.icon(
                          onPressed: controller.showAddDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter un client'),
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          client.nom[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        client.nom,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (client.telephone != null)
                            Text('📞 ${client.telephone}'),
                          if (client.email != null) Text('✉️ ${client.email}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => controller.showEditDialog(client),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteClient(client.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
