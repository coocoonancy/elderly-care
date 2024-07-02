import { ResManager } from '@hm/basic/Index';
import { router } from '@kit.ArkUI';
import { updateUserNameApi } from '@hm/basic/src/main/ets/api/UserApi';

@Entry
@Component
struct NickNamePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  nickname: string = '';

  aboutToAppear(): void {
    const params: object = router.getParams()
    this.nickname = params['name']
  }

  // 提交
  // 提交
  async save() {
    await updateUserNameApi(this.nickname)
    router.back()
  }

  build() {
    Navigation() {
      Column() {
        // Text(this.nickname)
        TextInput({ text: $$this.nickname, placeholder: '请输入昵称' })
          .height(50)
          .borderRadius(ResManager.EC_NORMAL_RD)
          .backgroundColor('#fff')
          .placeholderColor(ResManager.EC_MID_99)
        //   提交
        Button('保存', { type: ButtonType.Capsule })
          .margin({ top: 50 })
          .width(230)
          .enabled(false)
          .onClick(() => {
            this.save()
          })
      }
      .margin({ left: 15, right: 15 })

    }
    .title('昵称')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}