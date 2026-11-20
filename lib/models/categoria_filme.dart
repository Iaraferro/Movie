/// Categorias que o usuário pode escolher na Home.
/// O [titulo] é o texto mostrado no chip.
enum CategoriaFilme {
  populares('Populares'),
  melhoresNotas('Mais bem avaliados'),
  emCartaz('Em cartaz'),
  emBreve('Em breve');

  final String titulo;
  const CategoriaFilme(this.titulo);
}