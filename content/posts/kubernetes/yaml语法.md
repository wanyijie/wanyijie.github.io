### 语法


除某些[控制字符](https://en.wikipedia.org/wiki/Control_character "控制角色")外，YAML语言接受整个Unicode字符集。所有可接受的字符都可以在YAML文档中使用。YAML文档可以用[UTF-8](https://en.wikipedia.org/wiki/UTF-8 "UTF-8")，[UTF-16](https://en.wikipedia.org/wiki/UTF-16 "UTF-16")和[UTF-32编码](https://en.wikipedia.org/wiki/UTF-32 "UTF-32")。（虽然UTF-32不是强制性的，但如果解析器具有[JSON](https://en.wikipedia.org/wiki/JSON "JSON")兼容性，则必须使用它。）

*   [空格](https://en.wikipedia.org/wiki/Whitespace_(computer_science) "空白（计算机科学）") [缩进](https://en.wikipedia.org/wiki/Indent_style "缩进风格")用于表示结构; 但是，绝不允许[制表符](https://en.wikipedia.org/wiki/Tab_character "制表符")作为缩进。
*   注释以[井号](https://en.wikipedia.org/wiki/Number_sign "数字标志")（`#`）开头，可以从一行开始，一直持续到行尾。必须通过空格字符将注释与其他标记分开。<sup>[[13]](https://en.wikipedia.org/wiki/YAML#cite_note-13)</sup> 如果＃字符出现在字符串中，则它们是数字符号（`#`）文字。
*   列表成员由前导[连字符](https://en.wikipedia.org/wiki/Hyphen-minus "连字号 - 减号")（`-`）表示，每行一个成员，或用[方括号](https://en.wikipedia.org/wiki/Square_brackets "方括号")（`[ ]`）括起，并用[逗号](https://en.wikipedia.org/wiki/Comma_(punctuation) "逗号（标点符号）") [空格](https://en.wikipedia.org/wiki/Space_(punctuation) "空格（标点符号）")（`, `）分隔。
*   关联数组使用[冒号](https://en.wikipedia.org/wiki/Colon_(punctuation) "冒号（标点符号）") [空格](https://en.wikipedia.org/wiki/Space_(punctuation) "空格（标点符号）")（`: `）以表格*key：value表示*，每行一个或用[花括号](https://en.wikipedia.org/wiki/Curly_braces "大括号")（`{ }`）括起来并用[逗号](https://en.wikipedia.org/wiki/Comma_(punctuation) "逗号（标点符号）") [空格](https://en.wikipedia.org/wiki/Space_(punctuation) "空格（标点符号）")（`, `）分隔。
    *   关联数组键可以以[问号](https://en.wikipedia.org/wiki/Question_mark "问号")（`?`）为前缀，以允许明确地表示自由多字键。
*   字符串（[标量](https://en.wikipedia.org/wiki/Scalar_(computing) "标量（计算）")）通常不加引号，但可以用[双引号](https://en.wikipedia.org/wiki/Double_quote "双引号")（`"`）或[单引号](https://en.wikipedia.org/wiki/Single_quote "单引号")（`'`）[括起来](https://en.wikipedia.org/wiki/Single_quote "单引号")。
    *   在双引号内，特殊字符可以用[反斜杠](https://en.wikipedia.org/wiki/Backslash "反斜杠")（）开头的[C风格](https://en.wikipedia.org/wiki/C_(programming_language) "C（编程语言）")转义序列表示。根据文档，支持的唯一八进制转义是。[](https://en.wikipedia.org/wiki/Backslash "反斜杠")`\``\0`
*   块标量用[缩进](https://en.wikipedia.org/wiki/Indent_style "缩进风格")分隔，并带有可选修饰符以保留（`|`）或fold（`>`）换行符。
*   单个流中的多个文档由三个[连字符](https://en.wikipedia.org/wiki/Hyphens "连字符")（`---`）分隔。
    *   三个[句点](https://en.wikipedia.org/wiki/Full_stop "完全停止")（`...`）可选地结束流中的文档。
*   重复节点最初用[＆符号](https://en.wikipedia.org/wiki/Ampersand "和号")（`&`）表示，然后用[星号](https://en.wikipedia.org/wiki/Asterisk "星号")（`*`）引用。
*   节点可以使用[感叹号](https://en.wikipedia.org/wiki/Exclamation_point "感叹号")（`!!`）后跟一个字符串来标记类型或标记，该字符串可以扩展为URI。
*   流中的YAML文档可以在“指令”之后，该指令由[百分号](https://en.wikipedia.org/wiki/Percent_sign "百分号")（`%`）后跟名称和空格分隔的参数组成。YAML 1.1中定义了两个指令：
    *   ％YAML指令用于标识给定文档中的YAML版本。
    *   ％TAG指令用作URI前缀的快捷方式。然后可以在节点类型标签中使用这些快捷方式。

YAML要求用作列表分隔符的冒号和逗号后跟空格，以便通常可以表示包含嵌入标点符号（例如`5,280`或`http://www.jianshu.com`）的标量值，而无需用引号括起来。

YAML中保留了两个额外的[sigil](https://en.wikipedia.org/wiki/Sigil_(computer_programming) "Sigil（计算机编程）")字符，以便将来标准化：[at符号](https://en.wikipedia.org/wiki/At_sign "在标志")（`@`）和[重音符号](https://en.wikipedia.org/wiki/Accent_grave "口音坟墓")（```）。
