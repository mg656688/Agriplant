import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/market/cubit/market_cubit.dart';

class CustomBlocProviderInit extends StatelessWidget {
  const CustomBlocProviderInit({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => MarketCubit(),
      )
    ], child: child);
  }
}
