import { Log } from '@abner/log/src/main/ets/Log'
import { picker } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'
import { camera, cameraPicker } from '@kit.CameraKit'

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  // 回调函数=> 把子组件数据传递给父组件
  callback: (uri: string) => void = () => {
  }

  // 拍照
  async taskPhoto() {
    try {
      let photoContext = getContext(this) as common.Context;
      const pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      }
      const pickerResult = await cameraPicker.pick(photoContext, [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile)
      console.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
      Log.info(pickerResult.resultUri)
      // 回传
      this.callback(pickerResult.resultUri)
    } catch (error) {
      let err = error as BusinessError;
      Log.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  // 选择相册
  async selectPhoto() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions()
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.maxSelectNumber = 1
      const photoViewPicker = new picker.PhotoViewPicker()
      const result = await photoViewPicker.select(photoSelectOptions);
      // 得到文件路径
      Log.info(result.photoUris[0])
      //   回传数据
      this.callback(result.photoUris[0])
    } catch (error) {
      let err = error as BusinessError;
      Log.error(`the pick call failed. error code: ${err.code}`);
    }

  }

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => this.taskPhoto())

        ListItem() {
          Text('从相册选择')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => this.selectPhoto())

        ListItem() {
          Text('取消')
            .fontColor($r('app.color.ec_mid_59'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: $r('app.color.ec_mid_line') })
      .padding($r('app.float.ec_content_space'))
      .backgroundColor('#fff')
      .borderRadius($r('app.float.ec_normal_radius'))

    }
  }
}
