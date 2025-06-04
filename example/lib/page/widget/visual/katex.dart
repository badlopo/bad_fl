import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class KatexPage extends StatelessWidget {
  const KatexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BadText('Katex'),
      ),
      body: ListView(
        children: [
          BadKatex(
            raw:
                r"We consider the defocusing nonlinear Schrödinger equation on $\mathbb{T}^2$ with Wick ordered power nonlinearity, and prove almost sure global well-posedness with respect to the associated Gibbs measure. The heart of the matter is the uniqueness of the solution as limit of solutions to canonically truncated systems, and the invariance of the Gibbs measure under the global dynamics follows as a consequence. The proof relies on the novel idea of random averaging operators.",
          ),
        ],
      ),
    );
  }
}
