import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

const _katexExamples = [
  ('代数', r'$$x ={-b \pm \sqrt{b^2-4ac}\over 2a}$$'),
  (
    '几何',
    r'$$\left.\begin{matrix}   a \subset \beta ,b \subset \beta ,a \cap b=P \\    a \parallel \partial ,b \parallel \partial  \end{matrix}\right\}\Rightarrow \beta \parallel \alpha $$'
  ),
  (
    '不等式',
    r'$$\left | a-b \right | \geqslant \left | a \right | -\left | b \right | $$'
  ),
  (
    '积分',
    r'$$f(x) = \int_{-\infty}^\infty  \hat f(x)\xi\,e^{2 \pi i \xi x}  \,\mathrm{d}\xi $$'
  ),
  (
    '矩阵',
    r'$$A_{m\times n}=  \begin{bmatrix}    a_{11}& a_{12}& \cdots  & a_{1n} \\    a_{21}& a_{22}& \cdots  & a_{2n} \\    \vdots & \vdots & \ddots & \vdots \\    a_{m1}& a_{m2}& \cdots  & a_{mn}  \end{bmatrix}  =\left [ a_{ij}\right ] $$'
  ),
  (
    '三角函数',
    r'$$\sin \alpha - \sin \beta =2 \cos \frac{\alpha + \beta}{2}\sin \frac{\alpha - \beta}{2} $$'
  ),
  (
    '统计',
    r'$$\begin{array}{c}   \text{若}P \left( AB \right) =P \left( A \right) P \left( B \right) \\    \text{则}P \left( A \left| B\right. \right) =P \left({B}\right) \end{array}$$'
  ),
  (
    '数列',
    r'$$(1+x)^{n} =1 + \frac{nx}{1!} + \frac{n(n-1)x^{2}}{2!} + \cdots $$'
  ),
  ('物理', r'$$E = n{{ \Delta \Phi } \over {\Delta {t} }} $$'),
];
const _styleExample =
    r'若 $P \left( AB \right) =P \left( A \right) P \left( B \right)$ 则 $P \left( A \left| B\right. \right) =P \left({B}\right) $';

Iterable<Widget> _examples() sync* {
  for (final (title, katex) in _katexExamples) {
    yield BadText(
      title,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
    yield Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ColoredBox(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BadText(
            katex,
            color: Colors.black87,
            fontSize: 14,
            lineHeight: 21,
          ),
        ),
      ),
    );
    yield BadKatex(raw: katex);
  }
}

class KatexPage extends StatelessWidget {
  const KatexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ..._examples(),
        const BadText(
          '样式',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ColoredBox(
            color: Colors.grey.shade100,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: BadText(
                _styleExample,
                color: Colors.black87,
                fontSize: 14,
                lineHeight: 21,
              ),
            ),
          ),
        ),
        const BadKatex(
          raw: _styleExample,
          style: TextStyle(color: Colors.red),
          formulaStyle: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }
}
