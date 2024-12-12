export interface TabBarItemType {
  text: ResourceStr
}

export interface ConvertItemType {
  type: string
  text: ResourceStr
}

export interface ConvertSelected {
  type: string
}

export function genTabBars(): TabBarItemType[] {
  return [{
    text: '首页',
  }, {
    text: '转换',
  }, {
    text: '发现',
  }]
}

export function genConvertTypes(): ConvertItemType[] {
  return [{
    type: 'huawei',
    text: '华为'
  }, {
    type: 'zepp',
    text: 'Zepp'
  }, {
    type: 'xiaomi',
    text: '小米'
  }]
}