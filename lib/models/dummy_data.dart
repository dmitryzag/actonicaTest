import 'database.dart';

createDummyData() {
  SQLHelper.createData(
    'Продам собаку',
    'Человек собаке друг',
    SQLHelper.categoriesList[0].name,
    'Дмитрий',
    9059110772,
    'assets/images/no_photo.jpg',
    100,
  );

  SQLHelper.createData(
    'Продам чипсы',
    'БУ, чуть-чуть поел чипсинки',
    SQLHelper.categoriesList[1].name,
    'Андрей',
    9059110772,
    'assets/images/no_photo.jpg',
    200,
  );

  SQLHelper.createData(
    'Продам почку',
    'Да зачем мне она, все равно их две',
    SQLHelper.categoriesList[2].name,
    'Алексей',
    9059110772,
    'assets/images/no_photo.jpg',
    300,
  );

  SQLHelper.createData(
    'Продам гитару',
    'Хорошая гитара, наверное, никогда не играл',
    SQLHelper.categoriesList[0].name,
    'Ольга',
    9059110772,
    'assets/images/no_photo.jpg',
    400,
  );

  SQLHelper.createData(
    'Продам линейку',
    'Хорошая линейка, 30см, пользовался для чертежей',
    SQLHelper.categoriesList[1].name,
    'Оппенгеймер',
    9059110772,
    'assets/images/no_photo.jpg',
    500,
  );
}
