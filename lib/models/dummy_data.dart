import 'advert.dart';

createDummyData() {
  Advert.create(
    'Продам собаку',
    'Человек собаке друг',
    Advert.categoriesList[0].name,
    'Дмитрий',
    9059110772,
    '',
    100,
  );

  Advert.create(
    'Продам чипсы',
    'БУ, чуть-чуть поел чипсинки',
    Advert.categoriesList[1].name,
    'Андрей',
    9059110772,
    '',
    200,
  );

  Advert.create(
    'Продам почку',
    'Да зачем мне она, все равно их две',
    Advert.categoriesList[2].name,
    'Алексей',
    9059110772,
    '',
    300,
  );

  Advert.create(
    'Продам гитару',
    'Хорошая гитара, наверное, никогда не играл',
    Advert.categoriesList[0].name,
    'Ольга',
    9059110772,
    '',
    400,
  );

  Advert.create(
    'Продам линейку',
    'Хорошая линейка, 30см, пользовался для чертежей',
    Advert.categoriesList[1].name,
    'Оппенгеймер',
    9059110772,
    '',
    500,
  );
}
