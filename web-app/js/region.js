function getRegionLs() {
    return  new Array('安徽', '北京', '重庆', '福建', '甘肃', '广东', '广西', '贵州', '海南', '河北', '黑龙江', '河南', '湖北', '湖南', '内蒙古', '江苏', '江西', '吉林', '辽宁', '宁夏', '青海', '山西', '山东', '陕西', '上海', '四川', '天津', '西藏', '新疆', '云南', '浙江', '台湾', '香港', '澳门', '海外')
}

function getCityLs(region) {
    switch (region) {
        case '安徽':
            return new Array('合肥', '芜湖', '蚌埠', '淮南', '马鞍山', '淮北', '铜陵', '安庆', '黄山', '滁州', '阜阳', '宿州', '巢湖', '六安', '毫州', '池州', '宣城')

        case '北京':
            return new Array('东城', '西城', '朝阳', '丰台', '石景山', '海淀', '门头沟', '房山', '通州', '顺义', '昌平', '大兴', '怀柔', '平谷', '密云', '延庆')

        case '重庆':
            return new Array('渝中', '沙坪坝', '九龙坡', '大渡口', '江北', '渝北', '北碚', '南岸', '巴南', '万州', '涪陵', '黔江', '长寿', '万盛', '双桥', '永川', '合川', '江津', '南川', '綦江', '潼南', '荣昌', '璧山', '大足', '铜梁', '梁平', '城口', '垫江', '武隆', '丰都', '奉节', '开县', '云阳', '忠县', '巫溪', '巫山', '石柱土家族自治区', '秀山土家族苗族自治区')

        case '福建':
            return new Array('福州', '厦门', '莆田', '三明', '泉州', '漳州', '南平', '龙岩', '宁德')

        case '甘肃':
            return new Array('兰州', '嘉峪关', '金昌', '白银', '天水', '武威', '张掖', '平凉', '酒泉', '庆阳', '定西', '陇南', '临夏', '甘南')

        case '广东':
            return new Array('广州', '韶关', '深圳', '珠海', '汕头', '佛山', '江门', '湛江', '茂名', '肇庆', '惠州', '梅州', '汕尾', '河源', '阳江', '清远', '东莞', '中山', '潮州', '揭阳', '云浮')

        case '广西':
            return new Array('南宁', '柳州', '株洲', '桂林', '梧州', '北海', '防城港', '钦州', '贵港', '玉林', '百色', '贺州', '河池')

        case '贵州':
            return new Array('贵阳', '六盘水', '遵义', '安顺', '铜仁', '黔西南', '毕节', '黔东南', '黔南')

        case '海南':
            return new Array('海口', '三亚', '其他')

        case '河北':
            return new Array('石家庄', '唐山', '秦皇岛', '邯郸', '邢台', '保定', '张家口', '承德', '沧州', '廊坊', '衡水')

        case '黑龙江':
            return new Array('哈尔滨', '齐齐哈尔', '鸡西', '鹤岗', '双鸭山', '大庆', '伊春', '佳木斯', '七台河', '牡丹江', '黑河', '绥化', '大兴安岭')

        case '河南':
            return new Array('郑州', '开封', '洛阳', '平顶山', '安阳', '鹤壁', '新乡', '焦作', '濮阳', '许昌', '漯河', '三门峡', '南阳', '商丘', '信阳', '周口', '驻马店')

        case '湖北':
            return new Array('武汉', '黄石', '十堰', '宜昌', '襄樊', '鄂州', '荆门', '孝感', '荆州', '黄冈', '咸宁', '随州', '恩施')

        case '湖南':
            return new Array('长沙', '株洲', '湘潭', '衡阳', '邵阳', '岳阳', '常德', '张家界', '益阳', '郴州', '永州', '怀化', '娄底', '湘西')

        case '内蒙古':
            return new Array('呼和浩特', '包头', '乌海', '赤峰', '通辽', '鄂尔多斯', '呼伦贝尔', '兴安盟', '锡林郭勒盟', '乌兰察布盟', '巴彦淖尔盟', '阿拉善盟')

        case '江苏':
            return new Array('南京', '无锡', '徐州', '常州', '苏州', '南通', '连云港', '淮安', '盐城', '扬州', '镇江', '泰州', '宿迁')

        case '江西':
            return new Array('南昌', '景德镇', '萍乡', '九江', '新余', '鹰潭', '赣州', '吉安', '宜春', '抚州', '上饶')

        case '吉林':
            return new Array('长春', '吉林', '四平', '辽源', '通化', '白山', '松原', '白城', '延边')

        case '辽宁':
            return new Array('沈阳', '大连', '鞍山', '抚顺', '本溪', '丹东', '锦州', '营口', '阜新', '辽阳', '盘锦', '铁岭', '朝阳', '葫芦岛')

        case '宁夏':
            return new Array('银川', '石嘴山', '吴中', '固原')

        case '青海':
            return new Array('西宁', '海东', '海北', '黄南', '海南', '果洛', '玉树', '海西')

        case '山西':
            return new Array('太原', '大同', '阳泉', '长治', '晋城', '朔州', '晋中', '运城', '忻州', '临汾', '吕梁')

        case '山东':
            return new Array('济南', '青岛', '淄博', '枣庄', '东营', '烟台', '潍坊', '济宁', '泰安', '威海', '日照', '莱芜', '临沂', '德州', '聊城', '滨州', '菏泽')

        case '陕西':
            return new Array('西安', '铜川', '宝鸡', '咸阳', '渭南', '延安', '汉中', '榆林', '安康', '商洛')

        case '上海':
            return new Array('黄埔', '卢湾', '徐汇', '长宁', '静安', '普陀', '闸北', '虹口', '杨浦', '浦东新', '宝山', '闵行', '嘉定', '金山', '松江', '青浦', '奉贤', '南汇', '崇明')

        case '四川':
            return new Array('成都', '自贡', '攀枝花', '泸州', '德阳', '绵阳', '广元', '遂宁', '内江', '乐山', '南充', '眉山', '宜宾', '广安', '达州', '雅安', '巴中', '资阳', '阿坝', '甘孜', '凉山')

        case '天津':
            return new Array('和平', '河东', '河西', '南开', '河北', '红桥', '东丽', '西青', '津南', '北辰', '武清', '宝坻', '塘沽', '汉沽', '大港', '静海', '宁河', '蓟县')

        case '西藏':
            return new Array('拉萨', '昌都', '山南', '日喀则', '那曲', '阿里', '林芝')

        case '新疆':
            return new Array('乌鲁木齐', '克拉玛依', '吐鲁番', '哈密', '昌吉', '博尔塔拉', '巴音郭楞', '阿克苏', '克孜勒苏', '喀什', '和田', '伊犁', '塔城', '阿勒泰')

        case '云南':
            return new Array('昆明', '曲靖', '玉溪', '保山', '昭通', '楚雄', '红河', '文山', '思茅', '西双版纳', '大理', '德宏', '丽江', '怒江', '迪庆', '临沧')

        case '浙江':
            return new Array('杭州', '宁波', '温州', '嘉兴', '湖州', '绍兴', '金华', '衢州', '舟山', '台州', '丽水')

        case '台湾':
            return new Array('台北', '高雄', '台南', '基隆', '台中')

        case '香港':
            return new Array('香港岛', '九龙', '新界')

        case '澳门':
            return new Array('花地玛堂区', '圣安多尼堂区', '大堂区', '望德堂区', '风顺堂区')

        case '海外':
            return new Array('美国','英国','法国','德国','俄罗斯','加拿大','巴西','澳大利亚','印尼','泰国','马来西亚','新加坡','菲律宾','越南','印度','日本','韩国','其他')
    }
}

function getIndustryLs() {
    return  new Array(
            '计算机硬件及网络设备',
            '计算机软件',
            'IT服务(系统/数据/维护)/多领域经营',
            '互联网/电子商务',
            '网络游戏',
            '通讯(设备/运营/增值服务)',
            '电子技术/半导体/集成电路',
            '仪器仪表及工业自动化',
            '金融/银行/投资/基金/证券',
            '保险',
            '房地产/建筑/建材/工程',
            '家居/室内设计/装饰装潢',
            '物业管理/商业中心',
            '广告/会展/公共/市场推广',
            '媒体/出版/影视/文化/艺术',
            '印刷/包装/造纸',
            '咨询/管理产业/法律/财会',
            '教育/培训',
            '校验/检测/认证',
            '中介服务',
            '贸易/进出口',
            '零售/批发',
            '快速消费品(食品/饮料/烟酒/化妆品)',
            '耐用消费品(服装服饰/纺织/皮革/家具/家电)',
            '办公用品及设备',
            '礼品/玩具/工艺美术/收藏品',
            '大型设备/机电设备/重工业',
            '加工制造(原料加工/模具)',
            '汽车/摩托车(制造/维护/配件/销售/服务)',
            '交通/运输/物流',
            '医药/生物工程',
            '医疗/护理/美容/保健',
            '医疗设备/器械',
            '酒店/餐饮',
            '娱乐/体育/休闲',
            '旅游/度假',
            '石油/石化/化工',
            '能源/矿采/采掘/冶炼',
            '电气/电力/水利',
            '航空/航天',
            '学生/科研',
            '政府/公共事业/非盈利机构',
            '环保',
            '农/林/牧/渔',
            '跨领域经营',
            '其他'
            )
}