import router from '@ohos.router'
import { EcDialogUpload, EventId, ResManager, RouterConfig, uploadApi } from '@hm/basic'
import { Log } from '@abner/log'
import { UserData } from '@hm/basic/src/main/ets/viewmodel/UserModel'
import { EcLoading } from '@itheima/wing-care'
import fs from '@ohos.file.fs';
import { FormData } from '@ohos/axios'
import { updateUserPhotoApi } from '@hm/basic/src/main/ets/api/UserApi'
import { promptAction } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({
      callback: (uri) => {
        this.uploadDialog.close()
        Log.warn('上传的图片：' + uri)
        this.upload(uri)
      }
    }),
    alignment: DialogAlignment.Bottom
  })
  // 全屏 loading 弹层
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({ tip: '上传中...' }),
    customStyle: true,
    autoCancel: false,
    alignment: DialogAlignment.Center
  })
  // 1. 回填修改用户数据
  @StorageLink('user')
  user: UserData | null = null

  @Builder
  cellItem(title: string, flag: 0 | 1) {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row({ space: 10 }) {
        if (flag === 1) {
          // 昵称修改
          Text(this.user?.nickName)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
            .onClick(() => {
              router.pushUrl({
                url: RouterConfig.USER_NAME_URL
              })
            })
        } else {
          // 上传
          Image(this.user?.avatar ||
            'https://img2.baidu.com/it/u=130573784,2479509663&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=534')
            .width(34)
            .aspectRatio(1)
            .borderRadius(17)
            .onClick(() => {
              this.uploadDialog.open()
            })
        }
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  async upload(uri: string) {
    this.loading.open()
    try {
      // 拷贝沙箱
      const context = getContext(this)
      // 读取uri
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
      // 图片沙箱路径
      const copyFilePath = context.cacheDir + '/' + file.name
      // 2. 拷贝到沙箱准备上传
      fs.copyFileSync(file.fd, copyFilePath)


      let formData = new FormData()
      formData.append('file', `internal://cache/${file.name}`)
      // 调用 api 上传
      const url = await uploadApi(formData, context)
      Log.info('上传成功 oss地址：' + url)
      // 更新头像
      await updateUserPhotoApi(url)
      this.user!.avatar = url
      this.loading.close()
      promptAction.showToast({ message: '修改成功' })

    } catch (e) {
      this.loading.close()
      Log.error(e)
    }
  }

  getUser() {

  }

  aboutToAppear(): void {
    this.getUser()
    this.onUpdateUser()
  }

  onUpdateUser() {
    emitter.on(EventId.UpdateMine, (eventData) => {
      this.getUser()
    })
  }

  aboutToDisappear(): void {
    emitter.off(EventId.UpdateMine)
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          List() {
            ListItem() {
              this.cellItem('头像', 0)
            }

            ListItem() {
              this.cellItem('昵称', 1)
            }
          }
          .width('100%')
          .height('auto')
          .padding({ left: 14, right: 18, })
          .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        }
        .margin({
          top: ResManager.EC_CONTENT_SPACE,
          left: ResManager.EC_CONTENT_SPACE,
          right: ResManager.EC_CONTENT_SPACE
        })
        // .width('100%')
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('个人设置')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
  }
}