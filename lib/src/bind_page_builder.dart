part of 'route_manager.dart';

extension ImplementPageBind on BuildContext {
  B getBind<B>() {
    return BindPageBuilder.getBind<B>(this);
  }

  Future<void> removeAllBinds() async {
    await BindPageBuilder.removeAllBinds();
  }
}

/// Widget responsável por acoplar uma instância de um [Object]
/// para um outro [Widget] (página) filho usar como uma dependência (uma cotroller)
///
/// O mesmo tem o total controle para instânciar os objetos [builder] e [controller]
/// apenas quando serão usados
@immutable
class BindPageBuilder<B> extends StatefulWidget {
  const BindPageBuilder({
    Key? key,
    required this.builder,
    required this.controller,
    this.sigleton = true,
    this.lazy = true,
  }) : super(key: key);

  final WidgetBuilder builder;
  final B Function() controller;
  final bool sigleton;
  final bool lazy;

  static final Map<String, Object> _bindings = {};

  /// Obter o objeto de dependência vinculado a página
  static B getBind<B>(BuildContext context) {
    assert(B != dynamic,
        'Insira o tipo da dependência ou objeto no parâmentro genérico B');
    // instância de [_BindPageBuilderState]
    dynamic bindPageBuilderState = context.findAncestorStateOfType();
    //
    // chamar o método [controller] que não existe dentro da instância
    //  para o dart chamar o método [noSuchMethod] e retornar o valor de [_controllerInstance]
    try {
      return bindPageBuilderState.controller();
    } on TypeError catch (e, s) {
      printLog('O tipo de objeto $B é diferente do tipo de objeto existente.',
          name: 'BindPageBuilder', stackTrace: s);
      rethrow;
    }
  }

  /// Remover e disposar todos os binds
  static Future<void> removeAllBinds() async {
    if (_bindings.isNotEmpty) {
      await Future.forEach(_bindings.values, (bind) {
        dependencyDispose(bind);
      });
      _bindings.clear();
    }
  }

  @override
  State<BindPageBuilder> createState() => _BindPageBuilderState();
}

class _BindPageBuilderState<B> extends State<BindPageBuilder> {
  dynamic _controllerInstance;
  late final String _dependenceName;
  late final bool _containsKey;

  dynamic _getInstance() {
    if (widget.sigleton) {
      // Se sigleton == true, registre a instância na variável [_bindings]

      if (_containsKey) {
        if (!widget.lazy) {
          return _controllerInstance;
        } else {
          return BindPageBuilder._bindings[_dependenceName];
        }
      } else if (widget.lazy) {
        _controllerInstance = widget.controller();

        BindPageBuilder._bindings.putIfAbsent(
          _dependenceName,
          () => _controllerInstance,
        );

        return _controllerInstance;
      } else {
        BindPageBuilder._bindings.putIfAbsent(
          _dependenceName,
          () => _controllerInstance,
        );

        return _controllerInstance;
      }
    } else if (!widget.lazy) {
      return _controllerInstance;
    } else if (widget.lazy) {
      // Varificar se já exsite uma instância desse objeto mesmo não sendo singleton.
      //
      // Essa condição é útil caso a instância já foi criada em outra parte da árvore
      // de widgets
      if (_containsKey) {
        return _controllerInstance = BindPageBuilder._bindings[_dependenceName];
      } else {
        // Essa condição extra dará sempre a mesma instância do objeto
        // caso a instância seja solicitada mais uma vez, dessa forma
        // evita criar multliplas instâncias
        if (_controllerInstance != null) {
          return _controllerInstance;
        } else {
          return _controllerInstance = widget.controller();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _dependenceName = widget.controller.toString().split('=> ').last;
    _containsKey = BindPageBuilder._bindings.containsKey(_dependenceName);

    // se lazy for false, crie ou carregue a instância
    if (!widget.lazy) {
      if (_containsKey) {
        _controllerInstance = BindPageBuilder._bindings[_dependenceName];
      } else {
        _controllerInstance = widget.controller();
      }
    }
  }

  @override
  void dispose() {
    if (!widget.sigleton && !_containsKey && _controllerInstance != null) {
      dependencyDispose(_controllerInstance);
    }

    super.dispose();
  }

  @override
  B noSuchMethod(Invocation invocation) => _getInstance();

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
