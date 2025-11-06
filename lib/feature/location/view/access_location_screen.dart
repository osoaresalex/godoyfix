import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';


class AccessLocationScreen extends StatefulWidget {
  final bool? fromSignUp;
  final bool fromHome;
  final String? route;
  const AccessLocationScreen({super.key, @required this.fromSignUp, @required this.route, this.fromHome = false});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool isLoggedIn = false;
 AddressModel? _addressModel;

  @override
  void initState() {
    super.initState();

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);

    isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
    _addressModel = Get.find<LocationController>().getUserAddress();

    // Auto-solicitar localização na primeira entrada do app (somente Android/iOS)
    if ((GetPlatform.isAndroid || GetPlatform.isIOS) && !isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final savedAddress = Get.find<LocationController>().getUserAddress();
        if (kDebugMode) {
          print('🔍 Auto-location check: hasSavedAddress=${savedAddress != null}, isLoggedIn=$isLoggedIn');
        }
        // Só pegar localização automática se não tiver endereço salvo E não estiver logado
        if (savedAddress == null || savedAddress.address == null || savedAddress.address!.isEmpty) {
          if (kDebugMode) {
            print('✅ Iniciando captura automática de localização...');
          }
          _autoRequestAndFetchLocation();
        } else {
          if (kDebugMode) {
            print('❌ Já tem endereço salvo, pulando auto-location');
          }
        }
      });
    }

  }

  final shakeKey = GlobalKey<CustomShakingWidgetState>();

  bool _canExit = GetPlatform.isWeb ? true : false;
  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: () {
        if (_canExit) {
          if(!GetPlatform.isWeb) {
            exit(0);
          }
        } else {
          customSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: CustomAppBar(title: 'set_location'.tr, isBackButtonExist: false, shakeKey: shakeKey,),
        body: SafeArea(child: Center(
          child: GetBuilder<LocationController>(builder: (locationController) {
            return (ResponsiveHelper.isDesktop(context)) &&  !widget.fromHome ? WebLandingPage(fromSignUp: widget.fromSignUp,  route: widget.route, shakeKey: shakeKey,) :
            Column(
              children: [
                Expanded(
                  child: FooterBaseView(
                    isCenter: (! isLoggedIn || locationController.addressList == null || locationController.addressList!.isEmpty),
                    child: SizedBox(
                      width:Dimensions.webMaxWidth,
                      child: WebShadowWrap(
                        child: isLoggedIn ? Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              locationController.addressList != null ? locationController.addressList!.isNotEmpty ?
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: locationController.addressList!.length,
                                itemBuilder: (context, index) {
                                  return Center(child: SizedBox(width: 700, child: AddressWidget(
                                    address: locationController.addressList![index],
                                    fromAddress: false,
                                    onTap: () async {
                                      Get.dialog(const CustomLoader(), barrierDismissible: false);
                                      AddressModel address = locationController.addressList![index];
                                      await locationController.setAddressIndex(address,fromAddressScreen: false);
                                      locationController.saveAddressAndNavigate(address, widget.fromSignUp!, widget.route, widget.route != null, true);
                                    },
                                    selectedUserAddressId: locationController.getUserAddress()?.id,
                                  )));
                                },
                              ):
                              NoDataScreen(text: 'no_saved_address_found'.tr,type: NoDataType.address,) :
                              const Center(child: CircularProgressIndicator()),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                              if(ResponsiveHelper.isDesktop(context))
                                BottomButton(locationController: locationController, fromSignUp: widget.fromSignUp!, route: widget.route),
                            ],
                          ),
                        ):

                        Center(child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Center(child: SizedBox(
                              width: 700,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(Images.mapLocation, height: 240),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Text(
                                      'find_services_near_you'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeExtraLarge,
                                          color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.primary),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                      child: Text(
                                        'please_select_you_location_to_start_exploring_available_services_near_you'.tr,
                                        textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.primary
                                        ),),),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                    if(ResponsiveHelper.isDesktop(context))
                                      BottomButton(locationController: locationController, fromSignUp: widget.fromSignUp!, route: widget.route??''),
                                  ]))),
                        )),
                      ),
                    ),
                  ),
                ),
                if(!ResponsiveHelper.isDesktop(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: BottomButton(locationController: Get.find<LocationController>(), fromSignUp: widget.fromSignUp!, route: widget.route, previousAddress: _addressModel),
                  ),
              ],
            );
          }
          ),
        ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final LocationController locationController;
  final bool fromSignUp;
  final String? route;
  final AddressModel? previousAddress;
  const BottomButton({super.key, required this.locationController, required this.fromSignUp, required this.route, this.previousAddress});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: 700, child: Column(children: [

      CustomButton(
        buttonText: 'use_current_location'.tr,
        fontSize: Dimensions.fontSizeSmall,
        onPressed: () async {
          if(isRedundentClick(DateTime.now())){
            return;
          }
          _checkPermission(() async {
            Get.dialog(const CustomLoader(), barrierDismissible: false);
            AddressModel address = await locationController.getCurrentLocation(true,  deviceCurrentLocation: true);
            ZoneResponseModel response = await locationController.getZone(address.latitude!, address.longitude!, false);

            if(response.isSuccess) {
              locationController.saveAddressAndNavigate(address, fromSignUp, route != null ? route! : '', route != null, true);
            }else {
              Get.back();
              //Get.toNamed(RouteHelper.getPickMapRoute(route == null ? RouteHelper.accessLocation : route!, route != null, 'false', null, previousAddress));
              customSnackBar(response.message);
            }
          });
        },
        icon: Icons.my_location,
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),


      TextButton(
        style: TextButton.styleFrom(
            minimumSize: Size(Dimensions.webMaxWidth,ResponsiveHelper.isDesktop(context)?50 :40),
            padding: EdgeInsets.zero,
            backgroundColor: Get.isDarkMode? Colors.grey.withValues(alpha: 0.2):Theme.of(context).primaryColorLight
        ),

        onPressed: () {
          if(isRedundentClick(DateTime.now())){
            return;
          }
          Get.toNamed(RouteHelper.getPickMapRoute(
              route == null ? fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation : route!, route != null, 'false', null, Get.find<LocationController>().getUserAddress()
          ));
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall,left: Dimensions.paddingSizeExtraSmall),
            child: Icon(Icons.location_pin, color: Get.isDarkMode? Colors.white: Theme.of(context).primaryColor),
          ),
          Text('set_from_map'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(
            color:Get.isDarkMode? Colors.white: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeSmall,
          )),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),
    ])));
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied ) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}

// Extensão para auto-solicitação de localização
extension _AutoLocationRequest on _AccessLocationScreenState {
  Future<void> _autoRequestAndFetchLocation() async {
    try {
      if (kDebugMode) {
        print('📍 [AUTO-LOCATION] Iniciando...');
      }

      // Verificar se o serviço de localização está ativo
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (kDebugMode) {
        print('📍 [AUTO-LOCATION] GPS ativo: $serviceEnabled');
      }
      
      if (!serviceEnabled) {
        if (kDebugMode) {
          print('❌ [AUTO-LOCATION] GPS desligado, abrindo configurações...');
        }
        // Tentar abrir configurações de localização
        await Geolocator.openLocationSettings();
        return;
      }

      // Verificar permissão
      LocationPermission permission = await Geolocator.checkPermission();
      if (kDebugMode) {
        print('📍 [AUTO-LOCATION] Permissão atual: $permission');
      }
      
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('📍 [AUTO-LOCATION] Solicitando permissão...');
        }
        permission = await Geolocator.requestPermission();
        if (kDebugMode) {
          print('📍 [AUTO-LOCATION] Nova permissão: $permission');
        }
      }

      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('❌ [AUTO-LOCATION] Permissão negada');
        }
        // Não forçar, apenas deixar o usuário clicar no botão manualmente
        return;
      }

      if (kDebugMode) {
        print('📍 [AUTO-LOCATION] Buscando posição atual...');
      }

      // Buscar localização atual
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (kDebugMode) {
        print('✅ [AUTO-LOCATION] Posição obtida: ${position.latitude}, ${position.longitude}');
      }

      // Validar zona
      if (mounted) {
        Get.dialog(const CustomLoader(), barrierDismissible: false);
        
        if (kDebugMode) {
          print('📍 [AUTO-LOCATION] Validando zona...');
        }

        ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(
          position.latitude.toString(),
          position.longitude.toString(),
          false,
        );

        if (responseModel.isSuccess == true) {
          if (kDebugMode) {
            print('✅ [AUTO-LOCATION] Zona válida! Navegando...');
          }
          // Buscar endereço e salvar
          AddressModel newAddress = AddressModel(
            latitude: position.latitude.toString(),
            longitude: position.longitude.toString(),
          );
          
          Get.find<LocationController>().autoNavigate(
            newAddress,
            widget.fromSignUp!,
            widget.route,
            widget.route != null,
            null, // previousAddress
            true, // isServiceAvailable
          );
        } else {
          if (kDebugMode) {
            print('❌ [AUTO-LOCATION] Zona inválida: ${responseModel.message}');
          }
          Get.back();
          customSnackBar(responseModel.message);
        }
      }
    } catch (e) {
      // Erro ao buscar localização, silenciosamente ignora
      // O usuário pode clicar no botão manualmente
      if (kDebugMode) {
        print('❌ [AUTO-LOCATION] Erro: $e');
      }
    }
  }
}

