import 'package:demandium/common/widgets/custom_tooltip_widget.dart';
import 'package:demandium/common/widgets/radio_group.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ChooseBookingTypeWidget extends StatelessWidget {
  const ChooseBookingTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController){
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row( children: [
          Text("take_the_service".tr, style: robotoMedium,),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
          CustomToolTip(
            message: "take_the_service_hint".tr,
            preferredDirection: AxisDirection.down,
            child: Icon(Icons.help_outline_outlined,
              color: Get.isDarkMode ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ),
        ]),
        AppRadioGroup<ServiceType>(
          selected: scheduleController.selectedServiceType,
          onChanged: (value) {
            if (value == null) return;
            scheduleController.resetScheduleData(shouldUpdate: false);
            scheduleController.updateSelectedBookingType(type: value);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 0.5),
              color: Theme.of(context).cardColor
            ),
            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ?  Dimensions.paddingSizeDefault : 0,
              vertical: kIsWeb ? Dimensions.paddingSizeEight : 2,
            ),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),

            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              AppRadio<ServiceType>(
                value: ServiceType.regular,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              Text("only_once".tr),
            ]),
            Row(children: [
              AppRadio<ServiceType>(
                value: ServiceType.repeat,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              Text("multiple_times".tr),
            ]),
              const SizedBox(),
              const SizedBox(),
            ]),
          ),
        ),
      ]);
    });
  }
}