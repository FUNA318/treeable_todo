import 'package:app/repositories/user.dart';
import 'package:app/components/common/styles/field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_user.dart';
import '../common/styles/button.dart';

class SignupPage extends ConsumerWidget {
  SignupPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Text('利用登録', style: textTheme.headlineSmall),
                const SizedBox(height: 24),
                TextFormField(
                  controller: emailController,
                  decoration: TextInputFieldStyles.outlinedTextFieldStyle
                      .copyWith(hintText: 'メールアドレス'),
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return '正しいメールアドレスを入力してください。';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: TextInputFieldStyles.outlinedTextFieldStyle
                      .copyWith(hintText: 'パスワード'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '正しいパスワードを入力してください。';
                    } else if (value.length < 4) {
                      return 'パスワードが短すぎます。';
                    } else if (value.length > 100) {
                      return 'パスワードが長すぎます。';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButtonStyles.primaryFilledButtonStyle,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState?.save();
                          await UserRepository().signup(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          await ref.read(authUserProvider.notifier).fetchUser();
                        },
                        child: const Text('登録する'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButtonStyles.primaryTextButtonStyle,
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text('すでに登録済みの方はこちら'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
