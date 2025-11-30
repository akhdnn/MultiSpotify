import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class ProfileEditModal extends ConsumerStatefulWidget {
  const ProfileEditModal({super.key});

  @override
  ConsumerState<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends ConsumerState<ProfileEditModal> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loadingEmail = false;
  bool loadingPassword = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);

    email.text = user?.email ?? "";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 20),

            // EMAIL
            TextField(
              controller: email,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: 20),

            loadingEmail
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loadingEmail = true);

                      final updated = await ref
                          .read(updateProfileUsecaseProvider)
                          .updateEmail(email.text.trim());

                      if (updated != null) {
                        ref.read(authControllerProvider.notifier).login(
                              updated.email,
                              "", // tidak login ulang
                            );
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("Update Email"),
                  ),

            const SizedBox(height: 30),

            // PASSWORD
            TextField(
              controller: password,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Password Baru",
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: 20),

            loadingPassword
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loadingPassword = true);

                      await ref
                          .read(updateProfileUsecaseProvider)
                          .updatePassword(password.text.trim());

                      Navigator.pop(context);
                    },
                    child: const Text("Update Password"),
                  ),
          ],
        ),
      ),
    );
  }
}
