import { ConvertItemType, PreviewItemType, TabBarItemType } from "../utils/interface";

export const TAB_BARS: TabBarItemType[] = [{
  type: 'index',
  text: '首页',
  icon: $r('app.media.tab_home'),
  iconActive: $r('app.media.tab_home_active'),
}, {
  type: 'convert',
  text: '转换',
  icon: $r('app.media.tab_convert'),
  iconActive: $r('app.media.tab_convert_active'),
}, {
  type: 'discovery',
  text: '发现',
  icon: $r('app.media.tab_discover'),
  iconActive: $r('app.media.tab_discover_active'),
}, {
  type: 'more',
  text: '更多',
  icon: $r('app.media.tab_more'),
  iconActive: $r('app.media.tab_more_active'),
}]

export const PREVIEW_TYPES: PreviewItemType[] = [{
  type: 'huawei',
  text: '华为运动健康导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/huawei_coros.jpeg',
}, {
  type: 'zepp',
  text: 'Zepp Life、小米运动健康官方导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/zepp_coros.jpeg',
},  {
  type: 'zepp_sync',
  text: 'Zepp Life模拟登录导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/zepp_coros.jpeg',
}, {
  type: 'keep',
  text: 'Keep官方导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/e1f271e14498e13ab2b9891d1cf24b8.jpg',
}, {
  type: 'keep_sync',
  text: 'Keep模拟登录导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/20240505173019.png',
}, {
  type: 'codoon_sync',
  text: '咕咚模拟登录导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/20240505173019.png',
}, {
  type: 'joyrun_sync',
  text: '悦跑圈模拟登录导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/20240505173019.png',
}, {
  type: 'rqrun_sync',
  text: 'RQrun模拟登录导出数据',
  url: 'https://wp-img.daozhao.com/fitconverter/30713fe719a87a3195882bb94bfcf1d.jpg',
}]

export const CONVERT_TYPES: ConvertItemType[] = [{
  type: 'huawei',
  text: '华为运动健康',
  width: '50%',
  fileList: ['Motion path detail data & description/motion path detail data.json'],
  fileImgUrl: 'https://wp-img.daozhao.com/fitconverter/zip-intro-huawei.png',
}, {
  type: 'zepp',
  text: 'Zepp Life（原小米运动）',
  width: '100%',
  fileList: ['ACTIVITY_MINUTE/ACTIVITY_MINUTE_xxx.csv', 'HEARTRATE_AUTO/HEARTRATE_AUTO_xxx.csv', 'SPORT/SPOR_xxx.csv'],
  fileImgUrl: 'https://wp-img.daozhao.com/fitconverter/zip-intro-zepp.png',
}, {
  type: 'xiaomi',
  text: '小米运动健康（原小米穿戴）',
  width: '100%',
  fileList: ['XXX_MiFitness_hlth_center_fitness_data.csv', 'XXX_MiFitness_hlth_center_sport_record.csv'],
  fileImgUrl: 'https://wp-img.daozhao.com/fitconverter/zip-intro-xiaomi.png',
}, {
  type: 'keep',
  text: 'Keep',
  width: '30%',
  fileList: ['XXX.xlsx'],
  fileImgUrl: 'https://wp-img.daozhao.com/fitconverter/zip-intro-keep.png',
}, {
  type: 'gpx',
  text: 'gpx文件',
  width: '30%',
}, {
  type: 'tcx',
  text: 'tcx文件',
  width: '30%',
}, {
  type: 'fit',
  text: 'fit文件',
  width: '30%',
}, {
  type: 'zepp_sync',
  text: 'Zepp Life（模拟登录）',
  width: '70%',
}, {
  type: 'keep_sync',
  text: 'Keep（模拟登录）',
  width: '70%',
}, {
  type: 'codoon',
  text: '咕咚（模拟登录）',
  width: '70%',
}, {
  type: 'joyrun',
  text: '悦跑圈（模拟登录）',
  width: '80%',
}]


export const CONVERT_DESTINATIONS: ConvertItemType[] = [{
  type: 'coros',
  text: '高驰',
  width: '30%',
}, {
  type: 'garmin',
  text: '佳明',
  width: '30%',
}, {
  type: 'huawei',
  text: '华为',
  width: '30%',
}, {
  type: 'strava',
  text: 'Strava',
  width: '30%',
}, {
  type: 'rqrun',
  text: 'QRrun',
  width: '30%',
}, {
  type: 'keep',
  text: 'Keep',
  width: '30%',
}, {
  type: 'shuzixindong',
  text: '数字心动',
  width: '50%',
}, {
  type: 'xingzhe',
  text: '行者',
  width: '30%',
}, {
  type: 'ipgsport',
  text: 'iGPSPORT迹驰',
  width: '50%',
}, {
  type: 'onelap',
  text: '顽鹿运动',
  width: '50%',
}, {
  type: 'fit',
  text: 'FIT文件',
  width: '50%',
}, {
  type: 'tcx',
  text: 'TCX文件',
  width: '50%',
}]

export const URL_CONVERT_TYPES: string[] = ['huawei', 'zepp', 'xiaomi', 'keep']
// 高亮态文字颜色
export const COLOR_ACTIVE = '#fe0000'
// blur态文字颜色
export const COLOR_BLUR = '#666666'