import 'database.dart';

void createDummyData() {
  SQLHelper.createData(
    'Продам собаку',
    'Человек собаке друг',
    SQLHelper.categoriesList[0].name,
    'Дмитрий',
    '123456789',
    null,
    100.0,
  );

  SQLHelper.createData(
    'Продам чипсы',
    'БУ, чуть-чуть поел чипсинки',
    SQLHelper.categoriesList[1].name,
    'Андрей',
    '987654321',
    null,
    200.0,
  );

  SQLHelper.createData(
    'Продам почку',
    'Да зачем мне она, все равно их две',
    SQLHelper.categoriesList[2].name,
    'Алексей',
    '555555555',
    null,
    300.0,
  );

  SQLHelper.createData(
    'Продам гитару',
    'Хорошая гитара, наверное, никогда не играл',
    SQLHelper.categoriesList[0].name,
    'Ольга',
    '777777777',
    null,
    400.0,
  );

  SQLHelper.createData(
    'Продам линейку',
    'Хорошая линейка, 30см, пользовался для чертежей',
    SQLHelper.categoriesList[1].name,
    'Robert Wilson',
    '999999999',
    null,
    500.0,
  );
}
