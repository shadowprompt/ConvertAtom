@CustomDialog
export struct ImageDialog {
  @Link imageUrl: string
  cancel?: () => void
  confirm?: () => void
  controller: CustomDialogController

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Image(this.imageUrl)
          .onClick(() => {
            this.controller.close();
          })
          .width('100%').height('auto');
      }.margin({ bottom: 10 })
      .padding(8)
      .width('100%')
    }
  }
}