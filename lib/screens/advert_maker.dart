import 'package:actonic_adboard/models/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AdvertMaker extends StatefulWidget {
  final int? adID;
  const AdvertMaker(this.adID, {Key? key}) : super(key: key);
  @override
  _AdvertMakerState createState() => _AdvertMakerState();
}

class _AdvertMakerState extends State<AdvertMaker> {
  // ignore: unused_field
  List<Map<String, dynamic>> _allData = [];
  Category? _selectedCategory;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _authorPhoneController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageController.text = pickedFile.path;
      });
    } else {
      setState(() {
        _imageController.text = '';
      });
    }
  }

  void _fillFieldsWithAd() async {
    final ad = await SQLHelper.getSingleData(widget.adID!);
    setState(() {
      _titleController.text = ad.first['title'];
      _descriptionController.text = ad.first['description'];
      _selectedCategory = SQLHelper.categoriesList
          .firstWhere((category) => category.name == ad.first['category']);
      _authorNameController.text = ad.first['author_name'];
      _authorPhoneController.text = ad.first['author_phone'].toString();
      _imageController.text = ad.first['image'].toString();
      _priceController.text = ad.first['price'].toString();
    });
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    if (widget.adID != null) {
      _fillFieldsWithAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.adID != null ? "Редактирование" : "Создание объявления")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                  validator: (value) {
                    if (value == '') {
                      return 'Введите название';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items: SQLHelper.categoriesList.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Категория'),
                  validator: (value) {
                    if (value == null) {
                      return 'Выберите категорию';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _authorNameController,
                  decoration: const InputDecoration(labelText: 'Имя автора'),
                  validator: (value) {
                    if (value == '') {
                      return 'Введите имя автора';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  controller: _authorPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Телефон автора',
                    prefixText: '+7',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (int.tryParse(value!) is! int) {
                      return 'Пожалуйста введите номер телефона автора';
                    } else if (value.length != 9) {
                      return 'Пожалуйста введите корректный телефона автора';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Цена ₽',
                    prefixText: '\u{20BD} ',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Добавить Изображение'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final title = _titleController.text;
                      final description = _descriptionController.text;
                      final category = _selectedCategory!.name;
                      final authorName = _authorNameController.text;
                      final authorPhone =
                          int.tryParse(_authorPhoneController.text)!;
                      final image = _imageController.text;
                      final price = _priceController.text.isEmpty
                          ? null
                          : double.parse(_priceController.text);

                      if (widget.adID != null) {
                        SQLHelper.updateData(
                          widget.adID!,
                          title,
                          description,
                          category,
                          authorName,
                          authorPhone,
                          image,
                          price,
                        );
                        Navigator.pop(context, true);
                      } else {
                        SQLHelper.createData(
                          title,
                          description,
                          category,
                          authorName,
                          authorPhone,
                          image,
                          price,
                        );
                      }

                      _titleController.clear();
                      _descriptionController.clear();
                      _selectedCategory = null;
                      _authorNameController.clear();
                      _authorPhoneController.clear();
                      _imageController.clear();
                      _priceController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Объявление ${widget.adID != null ? 'обновлено' : 'создано'}',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(widget.adID != null ? 'Обновить' : 'Создать'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
