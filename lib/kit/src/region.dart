import 'package:bad_fl/widget/src/clickable.dart';
import 'package:bad_fl/widget/src/input/input.dart';
import 'package:flutter/material.dart';

class Region {
  final String enName;
  final String cnName;
  final String countryCode;
  final int telCode;

  const Region({
    required this.enName,
    required this.cnName,
    required this.countryCode,
    required this.telCode,
  });

  /// `s` should be lowercase before calling this method.
  bool match(String s) {
    return enName.toLowerCase().contains(s) ||
        cnName.toLowerCase().contains(s) ||
        countryCode.toLowerCase().contains(s) ||
        telCode.toString().contains(s);
  }

  @override
  String toString() {
    return '[Region] $cnName ($telCode)';
  }
}

// TODO: 补全列表
const regions = [
  Region(enName: 'Angola', cnName: '安哥拉', countryCode: 'AO', telCode: 244),
  Region(enName: 'Afghanistan', cnName: '阿富汗', countryCode: 'AF', telCode: 93),
  Region(enName: 'Albania', cnName: '阿尔巴尼亚', countryCode: 'AL', telCode: 355),
  Region(enName: 'Algeria', cnName: '阿尔及利亚', countryCode: 'DZ', telCode: 213),
  Region(enName: 'Andorra', cnName: '安道尔共和国', countryCode: 'AD', telCode: 376),
  Region(enName: 'Anguilla', cnName: '安圭拉岛', countryCode: 'AI', telCode: 1264),
  Region(
      enName: 'Antigua and Barbuda',
      cnName: '安提瓜和巴布达',
      countryCode: 'AG',
      telCode: 1268),
  Region(enName: 'Argentina', cnName: '阿根廷', countryCode: 'AR', telCode: 54),
  Region(enName: 'Armenia', cnName: '亚美尼亚', countryCode: 'AM', telCode: 374),
  Region(enName: 'Ascension', cnName: '阿森松', countryCode: ' ', telCode: 247),
  Region(enName: 'Australia', cnName: '澳大利亚', countryCode: 'AU', telCode: 61),
  Region(enName: 'Austria', cnName: '奥地利', countryCode: 'AT', telCode: 43),
  Region(enName: 'Azerbaijan', cnName: '阿塞拜疆', countryCode: 'AZ', telCode: 994),
  Region(enName: 'Bahamas', cnName: '巴哈马', countryCode: 'BS', telCode: 1242),
  Region(enName: 'Bahrain', cnName: '巴林', countryCode: 'BH', telCode: 973),
  Region(enName: 'Bangladesh', cnName: '孟加拉国', countryCode: 'BD', telCode: 880),
  Region(enName: 'Barbados', cnName: '巴巴多斯', countryCode: 'BB', telCode: 1246),
  Region(enName: 'Belarus', cnName: '白俄罗斯', countryCode: 'BY', telCode: 375),
  Region(enName: 'Belgium', cnName: '比利时', countryCode: 'BE', telCode: 32),
  Region(enName: 'Belize', cnName: '伯利兹', countryCode: 'BZ', telCode: 501),
  Region(enName: 'Benin', cnName: '贝宁', countryCode: 'BJ', telCode: 229),
  Region(
      enName: 'Bermuda Is.', cnName: '百慕大群岛', countryCode: 'BM', telCode: 1441),
  Region(enName: 'Bolivia', cnName: '玻利维亚', countryCode: 'BO', telCode: 591),
  Region(enName: 'Botswana', cnName: '博茨瓦纳', countryCode: 'BW', telCode: 267),
  Region(enName: 'Brazil', cnName: '巴西', countryCode: 'BR', telCode: 55),
  Region(enName: 'Brunei', cnName: '文莱', countryCode: 'BN', telCode: 673),
  Region(enName: 'Bulgaria', cnName: '保加利亚', countryCode: 'BG', telCode: 359),
  Region(
      enName: 'Burkina-faso', cnName: '布基纳法索', countryCode: 'BF', telCode: 226),
  Region(enName: 'Burma', cnName: '缅甸', countryCode: 'MM', telCode: 95),
  Region(enName: 'Burundi', cnName: '布隆迪', countryCode: 'BI', telCode: 257),
  Region(enName: 'Cameroon', cnName: '喀麦隆', countryCode: 'CM', telCode: 237),
  Region(enName: 'Canada', cnName: '加拿大', countryCode: 'CA', telCode: 1),
  Region(enName: 'Cayman Is.', cnName: '开曼群岛', countryCode: ' ', telCode: 1345),
  Region(
      enName: 'Central African Republic',
      cnName: '中非共和国',
      countryCode: 'CF',
      telCode: 236),
  Region(enName: 'Chad', cnName: '乍得', countryCode: 'TD', telCode: 235),
  Region(enName: 'Chile', cnName: '智利', countryCode: 'CL', telCode: 56),
  Region(enName: 'China', cnName: '中国', countryCode: 'CN', telCode: 86),
  Region(enName: 'Colombia', cnName: '哥伦比亚', countryCode: 'CO', telCode: 57),
  Region(enName: 'Congo', cnName: '刚果', countryCode: 'CG', telCode: 242),
  Region(enName: 'Cook Is.', cnName: '库克群岛', countryCode: 'CK', telCode: 682),
  Region(
      enName: 'Costa Rica', cnName: '哥斯达黎加', countryCode: 'CR', telCode: 506),
  Region(enName: 'Cuba', cnName: '古巴', countryCode: 'CU', telCode: 53),
  Region(enName: 'Cyprus', cnName: '塞浦路斯', countryCode: 'CY', telCode: 357),
  Region(
      enName: 'Czech Republic', cnName: '捷克', countryCode: 'CZ', telCode: 420),
  Region(enName: 'Denmark', cnName: '丹麦', countryCode: 'DK', telCode: 45),
  Region(enName: 'Djibouti', cnName: '吉布提', countryCode: 'DJ', telCode: 253),
  Region(
      enName: 'Dominica Rep.',
      cnName: '多米尼加共和国',
      countryCode: 'DO',
      telCode: 1890),
  Region(enName: 'Ecuador', cnName: '厄瓜多尔', countryCode: 'EC', telCode: 593),
  Region(enName: 'Egypt', cnName: '埃及', countryCode: 'EG', telCode: 20),
  Region(
      enName: 'EI Salvador', cnName: '萨尔瓦多', countryCode: 'SV', telCode: 503),
  Region(enName: 'Estonia', cnName: '爱沙尼亚', countryCode: 'EE', telCode: 372),
  Region(enName: 'Ethiopia', cnName: '埃塞俄比亚', countryCode: 'ET', telCode: 251),
  Region(enName: 'Fiji', cnName: '斐济', countryCode: 'FJ', telCode: 679),
  Region(enName: 'Finland', cnName: '芬兰', countryCode: 'FI', telCode: 358),
  Region(enName: 'France', cnName: '法国', countryCode: 'FR', telCode: 33),
  Region(
      enName: 'French Guiana',
      cnName: '法属圭亚那',
      countryCode: 'GF',
      telCode: 594),
  Region(enName: 'Gabon', cnName: '加蓬', countryCode: 'GA', telCode: 241),
  Region(enName: 'Gambia', cnName: '冈比亚', countryCode: 'GM', telCode: 220),
  Region(enName: 'Georgia', cnName: '格鲁吉亚', countryCode: 'GE', telCode: 995),
  Region(enName: 'Germany', cnName: '德国', countryCode: 'DE', telCode: 49),
  Region(enName: 'Ghana', cnName: '加纳', countryCode: 'GH', telCode: 233),
  Region(enName: 'Gibraltar', cnName: '直布罗陀', countryCode: 'GI', telCode: 350),
  Region(enName: 'Greece', cnName: '希腊', countryCode: 'GR', telCode: 30),
  Region(enName: 'Grenada', cnName: '格林纳达', countryCode: 'GD', telCode: 1809),
  Region(enName: 'Guam', cnName: '关岛', countryCode: 'GU', telCode: 1671),
  Region(enName: 'Guatemala', cnName: '危地马拉', countryCode: 'GT', telCode: 502),
  Region(enName: 'Guinea', cnName: '几内亚', countryCode: 'GN', telCode: 224),
  Region(enName: 'Guyana', cnName: '圭亚那', countryCode: 'GY', telCode: 592),
  Region(enName: 'Haiti', cnName: '海地', countryCode: 'HT', telCode: 509),
  Region(enName: 'Honduras', cnName: '洪都拉斯', countryCode: 'HN', telCode: 504),
  Region(enName: 'Hongkong', cnName: '香港', countryCode: 'HK', telCode: 852),
  Region(enName: 'Hungary', cnName: '匈牙利', countryCode: 'HU', telCode: 36),
  Region(enName: 'Iceland', cnName: '冰岛', countryCode: 'IS', telCode: 354),
  Region(enName: 'India', cnName: '印度', countryCode: 'IN', telCode: 91),
  Region(enName: 'Indonesia', cnName: '印度尼西亚', countryCode: 'ID', telCode: 62),
  Region(enName: 'Iran', cnName: '伊朗', countryCode: 'IR', telCode: 98),
  Region(enName: 'Iraq', cnName: '伊拉克', countryCode: 'IQ', telCode: 964),
  Region(enName: 'Ireland', cnName: '爱尔兰', countryCode: 'IE', telCode: 353),
  Region(enName: 'Israel', cnName: '以色列', countryCode: 'IL', telCode: 972),
  Region(enName: 'Italy', cnName: '意大利', countryCode: 'IT', telCode: 39),
  Region(enName: 'Ivory Coast', cnName: '科特迪瓦', countryCode: ' ', telCode: 225),
  Region(enName: 'Jamaica', cnName: '牙买加', countryCode: 'JM', telCode: 1876),
  Region(enName: 'Japan', cnName: '日本', countryCode: 'JP', telCode: 81),
  Region(enName: 'Jordan', cnName: '约旦', countryCode: 'JO', telCode: 962),
  Region(
      enName: 'Kampuchea (Cambodia )',
      cnName: '柬埔寨',
      countryCode: 'KH',
      telCode: 855),
  Region(enName: 'Kazakstan', cnName: '哈萨克斯坦', countryCode: 'KZ', telCode: 327),
  Region(enName: 'Kenya', cnName: '肯尼亚', countryCode: 'KE', telCode: 254),
  Region(enName: 'Korea', cnName: '韩国', countryCode: 'KR', telCode: 82),
  Region(enName: 'Kuwait', cnName: '科威特', countryCode: 'KW', telCode: 965),
  Region(
      enName: 'Kyrgyzstan', cnName: '吉尔吉斯坦', countryCode: 'KG', telCode: 331),
  Region(enName: 'Laos', cnName: '老挝', countryCode: 'LA', telCode: 856),
  Region(enName: 'Latvia', cnName: '拉脱维亚', countryCode: 'LV', telCode: 371),
  Region(enName: 'Lebanon', cnName: '黎巴嫩', countryCode: 'LB', telCode: 961),
  Region(enName: 'Lesotho', cnName: '莱索托', countryCode: 'LS', telCode: 266),
  Region(enName: 'Liberia', cnName: '利比里亚', countryCode: 'LR', telCode: 231),
  Region(enName: 'Libya', cnName: '利比亚', countryCode: 'LY', telCode: 218),
  Region(
      enName: 'Liechtenstein',
      cnName: '列支敦士登',
      countryCode: 'LI',
      telCode: 423),
  Region(enName: 'Lithuania', cnName: '立陶宛', countryCode: 'LT', telCode: 370),
  Region(enName: 'Luxembourg', cnName: '卢森堡', countryCode: 'LU', telCode: 352),
  Region(enName: 'Macao', cnName: '澳门', countryCode: 'MO', telCode: 853),
  Region(
      enName: 'Madagascar', cnName: '马达加斯加', countryCode: 'MG', telCode: 261),
  Region(enName: 'Malawi', cnName: '马拉维', countryCode: 'MW', telCode: 265),
  Region(enName: 'Malaysia', cnName: '马来西亚', countryCode: 'MY', telCode: 60),
  Region(enName: 'Maldives', cnName: '马尔代夫', countryCode: 'MV', telCode: 960),
  Region(enName: 'Mali', cnName: '马里', countryCode: 'ML', telCode: 223),
  Region(enName: 'Malta', cnName: '马耳他', countryCode: 'MT', telCode: 356),
  Region(
      enName: 'Mariana Is', cnName: '马里亚那群岛', countryCode: ' ', telCode: 1670),
  Region(enName: 'Martinique', cnName: '马提尼克', countryCode: ' ', telCode: 596),
  Region(enName: 'Mauritius', cnName: '毛里求斯', countryCode: 'MU', telCode: 230),
  Region(enName: 'Mexico', cnName: '墨西哥', countryCode: 'MX', telCode: 52),
  Region(
      enName: 'Moldova, Republic of',
      cnName: '摩尔多瓦',
      countryCode: 'MD',
      telCode: 373),
  Region(enName: 'Monaco', cnName: '摩纳哥', countryCode: 'MC', telCode: 377),
  Region(enName: 'Mongolia', cnName: '蒙古', countryCode: 'MN', telCode: 976),
  Region(
      enName: 'Montserrat Is',
      cnName: '蒙特塞拉特岛',
      countryCode: 'MS',
      telCode: 1664),
  Region(enName: 'Morocco', cnName: '摩洛哥', countryCode: 'MA', telCode: 212),
  Region(enName: 'Mozambique', cnName: '莫桑比克', countryCode: 'MZ', telCode: 258),
  Region(enName: 'Namibia', cnName: '纳米比亚', countryCode: 'NA', telCode: 264),
  Region(enName: 'Nauru', cnName: '瑙鲁', countryCode: 'NR', telCode: 674),
  Region(enName: 'Nepal', cnName: '尼泊尔', countryCode: 'NP', telCode: 977),
  Region(
      enName: 'Netheriands Antilles',
      cnName: '荷属安的列斯',
      countryCode: ' ',
      telCode: 599),
  Region(enName: 'Netherlands', cnName: '荷兰', countryCode: 'NL', telCode: 31),
  Region(enName: 'New Zealand', cnName: '新西兰', countryCode: 'NZ', telCode: 64),
  Region(enName: 'Nicaragua', cnName: '尼加拉瓜', countryCode: 'NI', telCode: 505),
  Region(enName: 'Niger', cnName: '尼日尔', countryCode: 'NE', telCode: 227),
  Region(enName: 'Nigeria', cnName: '尼日利亚', countryCode: 'NG', telCode: 234),
  Region(enName: 'North Korea', cnName: '朝鲜', countryCode: 'KP', telCode: 850),
  Region(enName: 'Norway', cnName: '挪威', countryCode: 'NO', telCode: 47),
  Region(enName: 'Oman', cnName: '阿曼', countryCode: 'OM', telCode: 968),
  Region(enName: 'Pakistan', cnName: '巴基斯坦', countryCode: 'PK', telCode: 92),
  Region(enName: 'Panama', cnName: '巴拿马', countryCode: 'PA', telCode: 507),
  Region(
      enName: 'Papua New Cuinea',
      cnName: '巴布亚新几内亚',
      countryCode: 'PG',
      telCode: 675),
  Region(enName: 'Paraguay', cnName: '巴拉圭', countryCode: 'PY', telCode: 595),
  Region(enName: 'Peru', cnName: '秘鲁', countryCode: 'PE', telCode: 51),
  Region(enName: 'Philippines', cnName: '菲律宾', countryCode: 'PH', telCode: 63),
  Region(enName: 'Poland', cnName: '波兰', countryCode: 'PL', telCode: 48),
  Region(
      enName: 'French Polynesia',
      cnName: '法属玻利尼西亚',
      countryCode: 'PF',
      telCode: 689),
  Region(enName: 'Portugal', cnName: '葡萄牙', countryCode: 'PT', telCode: 351),
  Region(
      enName: 'Puerto Rico', cnName: '波多黎各', countryCode: 'PR', telCode: 1787),
  Region(enName: 'Qatar', cnName: '卡塔尔', countryCode: 'QA', telCode: 974),
  Region(enName: 'Reunion', cnName: '留尼旺', countryCode: ' ', telCode: 262),
  Region(enName: 'Romania', cnName: '罗马尼亚', countryCode: 'RO', telCode: 40),
  Region(enName: 'Russia', cnName: '俄罗斯', countryCode: 'RU', telCode: 7),
  Region(
      enName: 'Saint Lueia', cnName: '圣卢西亚', countryCode: 'LC', telCode: 1758),
  Region(
      enName: 'Saint Vincent',
      cnName: '圣文森特岛',
      countryCode: 'VC',
      telCode: 1784),
  Region(
      enName: 'Samoa Eastern',
      cnName: '东萨摩亚(美)',
      countryCode: ' ',
      telCode: 684),
  Region(
      enName: 'Samoa Western', cnName: '西萨摩亚', countryCode: ' ', telCode: 685),
  Region(enName: 'San Marino', cnName: '圣马力诺', countryCode: 'SM', telCode: 378),
  Region(
      enName: 'Sao Tome and Principe',
      cnName: '圣多美和普林西比',
      countryCode: 'ST',
      telCode: 239),
  Region(
      enName: 'Saudi Arabia', cnName: '沙特阿拉伯', countryCode: 'SA', telCode: 966),
  Region(enName: 'Senegal', cnName: '塞内加尔', countryCode: 'SN', telCode: 221),
  Region(enName: 'Seychelles', cnName: '塞舌尔', countryCode: 'SC', telCode: 248),
  Region(
      enName: 'Sierra Leone', cnName: '塞拉利昂', countryCode: 'SL', telCode: 232),
  Region(enName: 'Singapore', cnName: '新加坡', countryCode: 'SG', telCode: 65),
  Region(enName: 'Slovakia', cnName: '斯洛伐克', countryCode: 'SK', telCode: 421),
  Region(enName: 'Slovenia', cnName: '斯洛文尼亚', countryCode: 'SI', telCode: 386),
  Region(
      enName: 'Solomon Is', cnName: '所罗门群岛', countryCode: 'SB', telCode: 677),
  Region(enName: 'Somali', cnName: '索马里', countryCode: 'SO', telCode: 252),
  Region(enName: 'South Africa', cnName: '南非', countryCode: 'ZA', telCode: 27),
  Region(enName: 'Spain', cnName: '西班牙', countryCode: 'ES', telCode: 34),
  Region(enName: 'Sri Lanka', cnName: '斯里兰卡', countryCode: 'LK', telCode: 94),
  Region(enName: 'St.Lucia', cnName: '圣卢西亚', countryCode: 'LC', telCode: 1758),
  Region(
      enName: 'St.Vincent', cnName: '圣文森特', countryCode: 'VC', telCode: 1784),
  Region(enName: 'Sudan', cnName: '苏丹', countryCode: 'SD', telCode: 249),
  Region(enName: 'Suriname', cnName: '苏里南', countryCode: 'SR', telCode: 597),
  Region(enName: 'Swaziland', cnName: '斯威士兰', countryCode: 'SZ', telCode: 268),
  Region(enName: 'Sweden', cnName: '瑞典', countryCode: 'SE', telCode: 46),
  Region(enName: 'Switzerland', cnName: '瑞士', countryCode: 'CH', telCode: 41),
  Region(enName: 'Syria', cnName: '叙利亚', countryCode: 'SY', telCode: 963),
  Region(enName: 'Taiwan', cnName: '台湾省', countryCode: 'TW', telCode: 886),
  Region(enName: 'Tajikstan', cnName: '塔吉克斯坦', countryCode: 'TJ', telCode: 992),
  Region(enName: 'Tanzania', cnName: '坦桑尼亚', countryCode: 'TZ', telCode: 255),
  Region(enName: 'Thailand', cnName: '泰国', countryCode: 'TH', telCode: 66),
  Region(enName: 'Togo', cnName: '多哥', countryCode: 'TG', telCode: 228),
  Region(enName: 'Tonga', cnName: '汤加', countryCode: 'TO', telCode: 676),
  Region(
      enName: 'Trinidad and Tobago',
      cnName: '特立尼达和多巴哥',
      countryCode: 'TT',
      telCode: 1809),
  Region(enName: 'Tunisia', cnName: '突尼斯', countryCode: 'TN', telCode: 216),
  Region(enName: 'Turkey', cnName: '土耳其', countryCode: 'TR', telCode: 90),
  Region(
      enName: 'Turkmenistan', cnName: '土库曼斯坦', countryCode: 'TM', telCode: 993),
  Region(enName: 'Uganda', cnName: '乌干达', countryCode: 'UG', telCode: 256),
  Region(enName: 'Ukraine', cnName: '乌克兰', countryCode: 'UA', telCode: 380),
  Region(
      enName: 'United Arab Emirates',
      cnName: '阿拉伯联合酋长国',
      countryCode: 'AE',
      telCode: 971),
  Region(
      enName: 'United Kiongdom', cnName: '英国', countryCode: 'GB', telCode: 44),
  Region(
      enName: 'United States of America',
      cnName: '美国',
      countryCode: 'US',
      telCode: 1),
  Region(enName: 'Uruguay', cnName: '乌拉圭', countryCode: 'UY', telCode: 598),
  Region(
      enName: 'Uzbekistan', cnName: '乌兹别克斯坦', countryCode: 'UZ', telCode: 233),
  Region(enName: 'Venezuela', cnName: '委内瑞拉', countryCode: 'VE', telCode: 58),
  Region(enName: 'Vietnam', cnName: '越南', countryCode: 'VN', telCode: 84),
  Region(enName: 'Yemen', cnName: '也门', countryCode: 'YE', telCode: 967),
  Region(enName: 'Yugoslavia', cnName: '南斯拉夫', countryCode: 'YU', telCode: 381),
  Region(enName: 'Zimbabwe', cnName: '津巴布韦', countryCode: 'ZW', telCode: 263),
  Region(enName: 'Zaire', cnName: '扎伊尔', countryCode: 'ZR', telCode: 243),
  Region(enName: 'Zambia', cnName: '赞比亚', countryCode: 'ZM', telCode: 260),
];

class RegionPage extends StatefulWidget {
  const RegionPage({super.key});

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final BadInputController controller = BadInputController();

  List<Region> _regions = regions;

  void handleFilter(String s) {
    s = s.toLowerCase();
    setState(() {
      _regions = regions.where((region) => region.match(s)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('选择手机号归属地'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: BadSimpleInput(
              controller: controller,
              height: 36,
              borderRadius: 18,
              fill: Colors.black12,
              textStyle: TextStyle(fontSize: 14),
              placeholderStyle: TextStyle(fontSize: 14),
              placeholder: '搜索',
              prefixIcon: const Icon(Icons.search_outlined, size: 18),
              clearIcon: const Icon(Icons.clear),
              onChanged: handleFilter,
              onCleared: () => handleFilter(''),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final region in _regions)
                  BadClickable(
                    onClick: () => Navigator.pop(context, region),
                    child: Container(
                      height: 32,
                      child: Text('${region.cnName} (+${region.telCode})'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class RegionKit {
  static Future<Region?> showRegionPicker(BuildContext context) {
    return Navigator.push<Region?>(
      context,
      MaterialPageRoute(builder: (context) => const RegionPage()),
    );
  }
}
