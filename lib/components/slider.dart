class SliderData {
  int id;
  String image;
  String button;
  String description;
  int idSupermarket;

  SliderData(
      this.id, this.image, this.button, this.description, this.idSupermarket);
}

class SliderDataListData {
  List<SliderData> _list;

  List<SliderData> get list => _list;

  SliderDataListData() {
    this._list = [
      new SliderData(
          1,
           'https://www.grupoelektra.com.mx/images/1.JPG',
           'Colleccion',
           'Electra ofertas en tienda',
           1),
      new SliderData(
          3,
          
              'https://s.yimg.com/ny/api/res/1.2/VJdhhcQ9NB.0Ip72Jn5Y8A--~A/YXBwaWQ9aGlnaGxhbmRlcjtzbT0xO3c9ODAwO2lsPXBsYW5l/http://tech.buscafs.com/uploads/images/79063_1000x529.jpg',
           'Visit Store',
           'No esperes mas tiempo compralo ya!!!',
           1),
      new SliderData(
           4,
          
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSHgV_efG64bvUN9fJON2DvamHPZjM4eNIkPmONPPYxKJFQKdul&usqp=CAU',
          'Visit Store',
           'Dimersa Orfertas del día',
           3),
      new SliderData(
           5,
          
              'https://i0.wp.com/diariolalibertad.com/sitio/wp-content/uploads/2020/03/Captura-de-Pantalla-2020-03-14-a-las-3.46.57-p.-m..png?fit=609%2C351&ssl=1',
            'Explore',
           'TODO LOS PRODUCTOS DE PRIMERA NECESIDAD',
           3),
      new SliderData(
           6,
          
              'https://portal.andina.pe/EDPfotografia3/Thumbnail/2016/01/27/000337793W.jpg',
            'Visit Store',
           'Bodega doña Paty',
           2),
      new SliderData(
           7,
          
              'https://image.shutterstock.com/image-photo/bangkok-march-17-2016-washing-260nw-428385304.jpg',
            'Explore',
           'Precios vajos todos  los dias',
           2),
      new SliderData(
           8,
          
              'https://gestion.pe/resizer/_IBVootQcy5z5V-SRSLuw83lHg4=/980x528/smart/arc-anglerfish-arc2-prod-elcomercio.s3.amazonaws.com/public/ZHJE4VSBXNFVHH2N456XLVB6UM.jpg',
            'Explore',
           'Saga Falabella Ofertas en tienda',
           4),
      new SliderData(
           9,
          
              'https://falabella.scene7.com/is/image/FalabellaPE/190102-pc-liqui-electro-2-m?scl=1&qlt=100&cache=off',
            'Visit Store',
           'Descuento especial en televisores Smart Tv',
           4),
      new SliderData(
           10,
          
              'https://falabella.scene7.com/is/image/FalabellaPE/190109-pc-liqui-acceso-3-m?scl=1&qlt=100&cache=off',
            'Explore',
           'Descuentos en polos y shorts para damas',
           4),
      new SliderData(
           11,
          
              'https://falabella.scene7.com/is/image/FalabellaPE/190124-vf-04?scl=1&qlt=100&cache=off',
            'Visit Store',
           'Solo ho descuento  del 50% en pijamas ',
           4),
    ];
  }
}
