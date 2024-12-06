import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sigede_movil/core/services/cloudinary_service.dart';
import 'package:sigede_movil/modules/superadmin/data/datasources/admin_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/models/admin_model.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institution_new_model.dart';
import 'package:sigede_movil/modules/superadmin/domain/use_cases/post_institution.dart';
import 'package:sigede_movil/widgets.dart/error_dialog.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';
import 'package:sigede_movil/widgets.dart/success_dialog_super.dart';


class RegisterInstitution extends StatefulWidget {
  const RegisterInstitution({super.key});

  @override
  _RegisterInstitutionState createState() => _RegisterInstitutionState();
}

class _RegisterInstitutionState extends State<RegisterInstitution> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameInstController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _nameAdminController = TextEditingController();
  final TextEditingController _emailAdminController = TextEditingController();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  String? _imageError;
  File? _image;
  bool _isloading = false;
  int _currentStep = 0;
  bool _isObscure = true;
  bool _isValidName = true;
  bool _isValidAddress = true;
  bool _isValidUserEmail = true;
  bool _isValidPhoneNumber = true;
  bool _isValidAdminName = true;
  bool _isValidAdminEmail = true;
  String _imageUrl = '';
  int? _institutionId = 0;
  final GetIt getIt = GetIt.instance;

  Future<void> _registerInstitutionAndAdmin() async {
    _setLoadingState(true); // Activa el estado de carga
    try {
      // Crear la institución
      final institutionModel = InstitutionNewModel(
        institutionName: _nameInstController.text,
        institutionAddress: _addressController.text,
        institutionEmail: _emailController.text,
        institutionPhone: _phoneController.text,
        logo: _imageUrl,
      );

      final institutionResponse =
          await getIt<PostInstitution>().call(institutionModel);
      if (institutionResponse.id != null) {
        _institutionId = institutionResponse.id;
        // Crear el administrador
        final adminModel = AdminModel(
          name: _nameAdminController.text,
          email: _emailAdminController.text,
          fkInstitution: _institutionId,
        );

        final adminResponse =
            await getIt<AdminDataSource>().postAdmin(adminModel);

        if (adminResponse.status == 201) {
          showSuccessDialogSuper(
            context: context,
            message: "Institución y administrador registrados correctamente",
            onPressed: () {              
              _nameInstController.clear();
              _nameAdminController.clear();
              _emailAdminController.clear();
              _addressController.clear();
              _emailController.clear();
              _phoneController.clear();              
              setState(() {
                _currentStep = 0;  
                _imageUrl = ''; 
              });              
            },
          );
        } else {
          await showErrorDialog(
            context: context,
            message: "Error al registrar el administrador",
          );
        }
      } else {
        await showErrorDialog(
          context: context,
          message: "Error al registrar la institución",
        );
      }
    } catch (e) {
      await showErrorDialog(context: context, message: "Error inesperado: $e");
    } finally {
      _setLoadingState(false); // Desactiva el estado de carga
    }
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isloading = isLoading;
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        setState(() {
          _imageError = 'No se seleccionó ninguna imagen.';
        });
        return;
      }

      final String fileExtension =
          pickedFile.path.split('.').last.toLowerCase();
      final List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (!allowedExtensions.contains(fileExtension)) {
        setState(() {
          _imageError =
              'Formato de archivo no permitido. Selecciona una imagen válida (jpg, jpeg, png).';
        });
        return;
      }

      final File imageFile = File(pickedFile.path);
      final int fileSize = await imageFile.length(); // Tamaño en bytes.
      const int maxFileSize = 5 * 1024 * 1024; // 5 MB

      if (fileSize > maxFileSize) {
        setState(() {
          _imageError =
              'El archivo es demasiado grande. Tamaño máximo permitido: 5 MB.';
        });
        return;
      }

      if (!mounted) return; // Verifica que el widget siga montado.

      setState(() {
        _image = imageFile; // Guarda la imagen seleccionada
        _imageError = null; // Limpia el mensaje de error si la imagen es válida
      });
    } catch (e) {
      // Manejo de errores generales
      if (!mounted) return;
      setState(() {
        _imageError =
            'Ocurrió un error al seleccionar la imagen. Inténtalo nuevamente.';
      });
    }
  }

  Future<void> _uploadImage() async {
    // if (!_formKey.currentState!.validate()) return;
    // if (_image != null) {
    //   final imageUrl = await _cloudinaryService.uploadImage(_image!);
    //   if (imageUrl != null) {
    //     setState(() {
    //       _imageUrl = imageUrl;
    //     });
    //   } else {
    //     // Manejar el caso en que la carga falla
    //     print('Error al cargar la imagen');
    //   }
    // }
    // setState(() {
    //   _isloading = false;
    //   _currentStep = 1; // Cambia al segundo paso
    // });
  }

  String? validateEmailAdmin(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (value == null || value.isEmpty) {
      setState(() {
        _isValidAdminEmail = false;
      });
      return 'Por favor, ingrese su correo electrónico';
    } else if (!emailRegExp.hasMatch(value)) {
      setState(() {
        _isValidAdminEmail = false;
      });
      return 'Por favor, ingrese un correo electrónico válido';
    }
    setState(() {
      _isValidAdminEmail = true;
    });
    return null;
  }

  String? validateNameAdmin(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isValidAdminName = false;
      });
      return 'Campo obligatorio';
    }
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegExp.hasMatch(value)) {
      setState(() {
        _isValidAdminName = false;
      });
      return 'Solo se permiten letras';
    }
    if (value.trim() != value) {
      setState(() {
        _isValidAdminName = false;
      });
      return 'No debe contener espacios al inicio o al final';
    }
    if (value.length > 50) {
      setState(() {
        _isValidAdminName = false;
      });
      return 'No debe superar los 50 caracteres';
    }
    setState(() {
      _isValidAdminName = true;
    });
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isValidName = false;
      });
      return 'Campo obligatorio';
    }
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');
    if (!nameRegExp.hasMatch(value)) {
      setState(() {
        _isValidName = false;
      });
      return 'Solo se permiten letras y números';
    }
    if (value.trim() != value) {
      setState(() {
        _isValidName = false;
      });
      return 'No debe contener espacios al inicio o al final';
    }
    if (value.length > 50) {
      setState(() {
        _isValidName = false;
      });
      return 'No debe superar los 50 caracteres';
    }
    setState(() {
      _isValidName = true;
    });
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isValidAddress = false;
      });
      return 'Campo obligatorio';
    }
    final RegExp addressRegExp = RegExp(r'^[a-zA-Z0-9,.\s]+$');
    if (!addressRegExp.hasMatch(value)) {
      setState(() {
        _isValidAddress = false;
      });
      return 'Solo se permiten letras y números';
    }
    if (value.trim() != value) {
      setState(() {
        _isValidAddress = false;
      });
      return 'No debe contener espacios al inicio o al final';
    }
    if (value.length > 100) {
      setState(() {
        _isValidAddress = false;
      });
      return 'No debe superar los 100 caracteres';
    }
    setState(() {
      _isValidAddress = true;
    });
  }

  String? validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (value == null || value.isEmpty) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Por favor, ingrese su correo electrónico';
    } else if (!emailRegExp.hasMatch(value)) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Por favor, ingrese un correo electrónico válido';
    }
    setState(() {
      _isValidUserEmail = true;
    });
    return null;
  }

  String? validatePhoneNumber(String? value) {
    final RegExp phoneRegExp = RegExp(r'^[0-9]+$');
    if (value == null || value.isEmpty) {
      setState(() {
        _isValidPhoneNumber = false;
      });
      return 'Campo obligatorio';
    }
    if (!phoneRegExp.hasMatch(value)) {
      setState(() {
        _isValidPhoneNumber = false;
      });
      return 'Solo se permiten números';
    }
    if (value.trim() != value) {
      setState(() {
        _isValidPhoneNumber = false;
      });
      return 'No debe contener espacios al inicio o al final';
    }
    if (value.length < 10 || value.length > 10) {
      setState(() {
        _isValidPhoneNumber = false;
      });
      return 'Debe tener 10 dígitos';
    }
    setState(() {
      _isValidPhoneNumber = true;
    });
  }

  Widget buildFirstStep() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Paso 1 de 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'Registrar cliente',
              style: TextStyle(
                fontFamily: 'RubikOne',
                fontSize: 38,
                height: 1.2,
              ),
              textAlign: TextAlign.center, // Asegura que el texto esté centrado
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _image == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image,
                                            size: 30, color: Colors.grey),
                                        SizedBox(height: 5),
                                        Icon(Icons.add,
                                            size: 20, color: Colors.grey),
                                        SizedBox(height: 5),
                                        Text(
                                          "Toca para seleccionar",
                                          style: TextStyle(color: Colors.grey),
                                          maxLines:
                                              1, // Limita a una sola línea
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 20,
                              child: _imageError != null
                                  ? Text(
                                      _imageError!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      TextFormField(
                        validator: validateName,
                        controller: _nameInstController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Nombre de la institución',
                          labelStyle: TextStyle(
                            color: _isValidName
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          suffixIcon: Icon(
                            Icons.apartment,
                            color: _isValidName ? Colors.grey : Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                          ),
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: validateAddress,
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
                          labelStyle: TextStyle(
                            color: _isValidAddress
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          suffixIcon: Icon(
                            Icons.pin_drop_outlined,
                            color: _isValidAddress ? Colors.grey : Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            fontSize:
                                12, // Tamaño más pequeño para evitar desplazamientos significativos
                            height: 1.5, // Altura del texto
                          ),
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: validateEmail,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(
                            color: _isValidUserEmail
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          suffixIcon: Icon(
                            Icons.mail_outline,
                            color: _isValidUserEmail ? Colors.grey : Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            fontSize:
                                12, // Tamaño más pequeño para evitar desplazamientos significativos
                            height: 1.5, // Altura del texto
                          ),
                          helperText: '',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        validator: validatePhoneNumber,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Número telefónico',
                          labelStyle: TextStyle(
                            color: _isValidPhoneNumber
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          suffixIcon: Icon(
                            Icons.phone_outlined,
                            color:
                                _isValidPhoneNumber ? Colors.grey : Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            fontSize:
                                12, // Tamaño más pequeño para evitar desplazamientos significativos
                            height: 1.5, // Altura del texto
                          ),
                          helperText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: Column()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SizedBox(
                    width: 300,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isloading ? null : _uploadImage,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: _isloading
                          ? const LoadingWidget() // Mostrar loading si está cargando
                          : Text(
                              'Paso 2',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSecondStep() {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Spacer(),
            Text(
              "Paso 2 de 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Registrar Administrador',
            style: TextStyle(
              fontFamily: 'RubikOne',
              fontSize: 39,
              height: 1.2,
            ),
            textAlign: TextAlign.center, // Asegura que el texto esté centrado
          ),
          const SizedBox(height: 35),
          Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      _imageUrl,
                      width: 125,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 60.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      width: 150,
                      child: Text(
                        _nameInstController.text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                validator: validateNameAdmin,
                controller: _nameAdminController,
                decoration: InputDecoration(
                  labelText: 'Nombre administrador',
                  labelStyle: TextStyle(
                    color: _isValidAdminName
                        ? Colors.grey // Si la validación es exitosa
                        : Colors.red, // Si la validación falla
                  ),
                  suffixIcon: Icon(
                    Icons.admin_panel_settings_outlined,
                    color: _isValidAdminName ? Colors.grey : Colors.red,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: validateEmailAdmin,
                controller: _emailAdminController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(
                    color: _isValidAdminEmail
                        ? Colors.grey // Si la validación es exitosa
                        : Colors.red, // Si la validación falla
                  ),
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: _isValidAdminEmail ? Colors.grey : Colors.red,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
          const Expanded(child: Column()),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: SizedBox(
              width: 300,
              height: 48,
              child: ElevatedButton(
                onPressed: _isloading ? null : _registerInstitutionAndAdmin,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: _isloading
                    ? const LoadingWidget() // Mostrar loading si está cargando
                    : Text(
                        'Paso 2',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentStep == 0 ? buildFirstStep() : buildSecondStep(),
      ),
    );
  }
}
