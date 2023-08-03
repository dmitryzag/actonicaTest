import 'package:actonic_adboard/models/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DataForm extends StatefulWidget {
  final int? adID;
  const DataForm(this.adID, {Key? key}) : super(key: key);
  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  List<Map<String, dynamic>> _allData = [];
  Category? _selectedCategory;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _authorNameController = TextEditingController();
  TextEditingController _authorPhoneController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

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
    }
  }

  Future<void> _addData() async {
    await SQLHelper.createData(
      _titleController.text,
      _descriptionController.text,
      _selectedCategory!.name,
      _authorNameController.text,
      _authorPhoneController.text,
      _imageController.text,
      double.tryParse(_priceController.text),
    );
    _refreshData();
  }

  void _fillFieldsWithAd() async {
    final ad = await SQLHelper.getSingleData(widget.adID!);
    setState(() {
      _titleController.text = ad[0]['title'];
      _descriptionController.text = ad[0]['description'];
      _selectedCategory = SQLHelper.categoriesList
          .firstWhere((category) => category.name == ad[0]['category']);
      _authorNameController.text = ad[0]['author_name'];
      _authorPhoneController.text = ad[0]['author_phone'];
      _imageController.text = ad[0]['image'];
      _priceController.text = ad[0]['price'].toString();
    });
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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == '') {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание'),
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
                decoration: InputDecoration(labelText: 'Категория'),
                validator: (value) {
                  if (value == null) {
                    return 'Выберите категорию';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorNameController,
                decoration: InputDecoration(labelText: 'Имя автора'),
                validator: (value) {
                  if (value == '') {
                    return 'Введите имя автора';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorPhoneController,
                decoration: InputDecoration(labelText: 'Телефон автора'),
                validator: (value) {
                  if (value == '') {
                    return 'Пожалуйста введите номер телефона автора';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Добавить Изображение'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final category = _selectedCategory!.name;
                    final authorName = _authorNameController.text;
                    final authorPhone = _authorPhoneController.text;
                    final image = _imageController.text;
                    final price = double.tryParse(_priceController.text);

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
                              'Объявление ${widget.adID != null ? 'обновлено' : 'создано'}')),
                    );
                  }
                },
                child: Text(widget.adID != null ? 'Обновить' : 'Создать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
