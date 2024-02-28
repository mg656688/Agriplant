import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/bottom_navigation_cubit.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
          builder: (context, state) {
        if (state is BottomNavigationLoaded) {
          return Scaffold(
            body: state.pages[state.page],
            bottomNavigationBar: BottomNavigationBar(
                onTap:
                    BlocProvider.of<BottomNavigationCubit>(context).changeIndex,
                currentIndex: state.page,
                type: BottomNavigationBarType.fixed,
                items: context.read<BottomNavigationCubit>().items),
          );
        }
        return Container();
      }),
    );
  }
}
