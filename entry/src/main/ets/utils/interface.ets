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
}

export interface ConvertSelected {
  type: string
}