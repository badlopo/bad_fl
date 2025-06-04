import 'package:bad_fl/bad_fl.dart';
import 'package:example/component/codeblock.dart';
import 'package:example/component/html_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _katexExamples = [
  ('代数', r'x ={-b \pm \sqrt{b^2-4ac}\over 2a}'),
  (
    '几何',
    r'\left.\begin{matrix}   a \subset \beta ,b \subset \beta ,a \cap b=P \\    a \parallel \partial ,b \parallel \partial  \end{matrix}\right\}\Rightarrow \beta \parallel \alpha '
  ),
  (
    '不等式',
    r'\left | a-b \right | \geqslant \left | a \right | -\left | b \right | '
  ),
  (
    '积分',
    r'f(x) = \int_{-\infty}^\infty  \hat f(x)\xi\,e^{2 \pi i \xi x}  \,\mathrm{d}\xi '
  ),
  (
    '矩阵',
    r'A_{m\times n}=  \begin{bmatrix}    a_{11}& a_{12}& \cdots  & a_{1n} \\    a_{21}& a_{22}& \cdots  & a_{2n} \\    \vdots & \vdots & \ddots & \vdots \\    a_{m1}& a_{m2}& \cdots  & a_{mn}  \end{bmatrix}  =\left [ a_{ij}\right ] '
  ),
  (
    '三角函数',
    r'\sin \alpha - \sin \beta =2 \cos \frac{\alpha + \beta}{2}\sin \frac{\alpha - \beta}{2} '
  ),
  (
    '统计',
    r'\begin{array}{c}   \text{若}P \left( AB \right) =P \left( A \right) P \left( B \right) \\    \text{则}P \left( A \left| B\right. \right) =P \left({B}\right) \end{array}'
  ),
  ('数列', r'(1+x)^{n} =1 + \frac{nx}{1!} + \frac{n(n-1)x^{2}}{2!} + \cdots '),
  ('物理', r'E = n{{ \Delta \Phi } \over {\Delta {t} }} '),
];
const _styleExample =
    r'若 $P \left( AB \right) =P \left( A \right) P \left( B \right)$ 则 $P \left( A \left| B\right. \right) =P \left({B}\right) $';

Iterable<Widget> _examples() sync* {
  for (final (title, katex) in _katexExamples) {
    yield HtmlText.h3(title);
    yield CodeBlock(code: katex);
    yield BadKatex(raw: '\$\$$katex\$\$');
  }
}

class KatexPage extends StatefulWidget {
  const KatexPage({super.key});

  @override
  State<KatexPage> createState() => _KatexPageState();
}

class _KatexPageState extends State<KatexPage> {
  TextEditingController controller = TextEditingController(text: r'$$E=mc^2$$');
  String _string = r'$$E=mc^2$$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const HtmlText.h1('BadKatex'),
          const HtmlText.h2('Live Demo'),
          const HtmlText.p('请输入你的 Latex 表达式 (使用 \$ 或 \$\$ 包裹):'),
          ColoredBox(
            color: Colors.grey.shade100,
            child: CupertinoTextField.borderless(
              controller: controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              onChanged: (s) => setState(() {
                _string = s;
              }),
            ),
          ),
          BadKatex(raw: _string),
          const Divider(),
          const HtmlText.h2('Showcase'),
          ..._examples(),
          const Divider(),
          const HtmlText.h2('Formula Style'),
          const HtmlText.p('段落中的公式的样式可以通过 formulaStyle 来单独设置'),
          const CodeBlock(code: _styleExample),
          const BadKatex(
            raw: _styleExample,
            style: TextStyle(color: Colors.red),
            formulaStyle: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
