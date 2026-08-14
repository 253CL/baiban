
import common from '@ohos.app.ability.common';
import { FlutterPage } from '@ohos/flutter_ohos'

let storage = LocalStorage.getShared()
const EVENT_BACK_PRESS = 'EVENT_BACK_PRESS'

@Entry(storage)
@Component
struct Index {
  pathStack:NavPathStack = new NavPathStack()
  private context = getContext(this) as common.UIAbilityContext
  @LocalStorageLink('viewId') viewId: string = "";


  aboutToAppear(): void {
    AppStorage.setOrCreate<NavPathStack>('cl_pathstack', this.pathStack)
  }

  build() {
    Navigation(this.pathStack){
      Column() {
        FlutterPage({ viewId: this.viewId })
      }
    }
  }

  onBackPress(): boolean {
    this.context.eventHub.emit(EVENT_BACK_PRESS)
    return true
  }
}