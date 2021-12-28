import 'package:flutter/material.dart';

import '../../../core/extension/context_extension.dart';
import '../auth/auth_wrapper/auth_wrapper.dart';
import '../breaking_bad/characters_view.dart';

class InitialView extends StatelessWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.mediumValue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              Expanded(flex: 20, child: buildBreakingBadCard(context)),
              Expanded(
                flex: 20,
                child: buildEcommerceCard(context),
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildEcommerceCard(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CharactersView(),
              ),
            ),
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                "https://i.pinimg.com/originals/d3/bb/d0/d3bbd00fc97e601c6dabca395af2e7f6.png",
              ),
              borderRadius: BorderRadius.circular(context.lowValue),
            ),
            const Spacer(),
            Text(
              "Breaking Bad Characters",
              style: context.textTheme.headline6!
                  .copyWith(color: context.colors.onSecondary),
            ),
            const Spacer(
              flex: 5,
            ),
          ],
        ));
  }

  GestureDetector buildBreakingBadCard(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          ClipRRect(
            child: Image.network(
              "https://images.unsplash.com/photo-1483985988355-763728e1935b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
            ),
            borderRadius: BorderRadius.circular(context.lowValue),
          ),
          const Spacer(),
          Text(
            "E-commerce App",
            style: context.textTheme.headline6!
                .copyWith(color: context.colors.onSecondary),
          ),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthWrapper(),
        ),
      ),
    );
  }
}
