export interface TabBarItemType {
  type: string
  text: ResourceStr
  icon?: ResourceStr
  iconActive?: ResourceStr
}

export interface PreviewItemType {
  type: string
  text: ResourceStr
  url: string
}

export interface ConvertItemType {
  type: string
  text: ResourceStr
  width?: string
  isChecked?: boolean
  fileList?: string[]
  fileImgUrl?: string
}

export interface ConvertSelected {
  type: string
}

export interface RequestResult {
  code: number
}

export interface EventTriggerType {
  type: string,
  trigger: string,
  key: string
  value: string | number | boolean
}

export interface EventPayloadType {
  key: string
  value: string | number | boolean
}