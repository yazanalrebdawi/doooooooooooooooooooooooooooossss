import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class SuffixIconPass extends StatelessWidget {
  const SuffixIconPass({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.isObscurePassword != current.isObscurePassword,
      builder: (context, state) {
        return InkWell(
          onTap: () => context.read<AuthCubit>().togglePasswordVisibility(),
          child: Icon(
            (state.isObscurePassword ?? false)
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,

          ),
        );
      },
    );
  }
}