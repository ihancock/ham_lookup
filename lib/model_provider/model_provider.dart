import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ModelProvider extends StatefulWidget {
  final Widget child;

  const ModelProvider({super.key, required this.child});

  static ModelProviderState of(BuildContext context) {
    final _ModelProviderInherited? result =
        context.dependOnInheritedWidgetOfExactType<_ModelProviderInherited>();
    assert(result != null, 'No ModelProviderInherited found in context');
    return result!.data;
  }

  @override
  State<ModelProvider> createState() => ModelProviderState();
}

class ModelProviderState extends State<ModelProvider> {
  List<Model> models = [];

  @override
  Widget build(BuildContext context) {
    return _ModelProviderInherited(data: this, child: widget.child);
  }

  Model bindModel<T extends Model>(T Function() creator) {
    var model = models.firstWhereOrNull((e) => e is T);
    if (model == null) {
      model = creator();
      models.add(model);
    }
    return model;
  }

  void unbindModel(Model model) {
    models.removeWhere((e) => e.runtimeType == model.runtimeType);
  }
}

class _ModelProviderInherited extends InheritedWidget {
  final ModelProviderState data;

  const _ModelProviderInherited({
    // ignore: unused_element
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ModelProviderInherited old) {
    return false;
  }
}

mixin ModelListener<T> {
  bool isModelDirty = false;

  void onChanged();
}

abstract class ModelState<T extends StatefulWidget,
        C extends AbstractModelController> extends State<T>
    with ModelListener<Model> {
  late C controller;
  bool _initialized = false;

  ModelState({required this.controller}) : super();

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;
      controller._bind(context, this);
    }
    super.didChangeDependencies();
  }

  @override
  void onChanged() {
    if (isModelDirty) {
      isModelDirty = false;
      setState(() {});
    }
  }
}

abstract class AbstractModel {
  List<ModelListener> listeners = [];

  void bindListener(ModelListener listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  void unBindListener(ModelListener listener) {
    if (!listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }
}

abstract class AbstractModelController<T extends AbstractModel> {
  late BuildContext context;

  bool _isLoading = false;

  bool get isLoading;

  set isLoading(bool isLoading);

  void _bind(BuildContext context, ModelListener listener);

  void initialize(BuildContext context) {
    this.context = context;
  }
}

class ModelController<M extends Model> extends AbstractModelController {
  late M model;
  late M Function() _modelCreator;

  @override
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    model._notify();
  }

  @override
  bool get isLoading => _isLoading;

  ModelController({required M Function() modelCreator}) {
    _modelCreator = modelCreator;
  }

  @override
  void _bind(BuildContext context, ModelListener listener) {
    final modelProvider = ModelProvider.of(context);
    initialize(context);
    model = modelProvider.bindModel(_modelCreator) as M;
    model.unBindListener(listener);
    model.bindListener(listener);
  }

  void updateModel(void Function() voidCallback) {
    voidCallback();

    model._notify();
  }
}

class AggregateModelController extends AbstractModelController {
  List<ModelController<Model>> controllers = [];

  @override
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    controllers.first.model._notify();
  }

  bool get isLoading {
    var result = controllers.any((element) => element.isLoading) || _isLoading;
    return result;
  }

  C registerController<C extends ModelController>(C controller) {
    if (!controllers.contains(controller)) {
      controllers.add(controller);
    }
    return controller;
  }

  @override
  void _bind(BuildContext context, ModelListener listener) {
    for (final controller in controllers) {
      controller._bind(context, listener);
    }
  }
}

class Model extends AbstractModel {
  void _notify() {
    for (final listener in listeners) {
      listener.isModelDirty = true;
    }
    for (final listener in listeners) {
      if (listener.isModelDirty) {
        listener.onChanged();
      }
    }
  }
}
