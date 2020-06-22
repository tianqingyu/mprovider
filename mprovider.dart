import 'package:flutter/material.dart';

typedef MProviderCreateCallback<T extends ChangeNotifier> = List<T> Function();

class MProvider extends StatefulWidget {
  MProvider({
    @required this.create,
    @required this.child,
  });

  final Widget child;
  final MProviderCreateCallback create;

  static final Map<ChangeNotifier, Set<BuildContext>> _consumerContexts = {};

  /// 查找并返回离context最近的model
  /// 
  static T get<T extends ChangeNotifier>(BuildContext context) {
    if (context == null) return null;

    final element = context.getElementForInheritedWidgetOfExactType<_MProviderInheritedWidget>();
    if (element == null) return null;

    final widget = element.widget as _MProviderInheritedWidget;
    for (var model in widget.models) {
      if (model is T) {
        return model;
      }
    }

    Element parentElement;
    element.visitAncestorElements((parent) {
      parentElement = parent;
      return false;
    });

    return get(parentElement);
  }

  /// **实现局部刷新的核心代码**
  /// 
  /// 建立model和consumer context的关联关系，这样当
  /// model有变化时，就会立即通知到这些关联的context
  /// 
  static void _buildRelationshipFor<T extends ChangeNotifier>(BuildContext context, T model) {
    if (model == null) {
      throw ArgumentError.notNull('参数model为null');
    }

    if (!_consumerContexts.containsKey(model)) {
      _consumerContexts[model] = <BuildContext>{};
    }
    _consumerContexts[model].add(context);
  }

  @override
  _MProviderState createState() => _MProviderState();
}

class _MProviderState extends State<MProvider> {
  List<ChangeNotifier> models;

  @override
  void initState() {
    super.initState();
    
    models = widget.create();
    addListeners(models);
  }

  @override
  void dispose() {
    clean(models);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MProviderInheritedWidget(
      models: models,
      child: widget.child,
    );
  }

  void addListeners(List<ChangeNotifier> models) {
    for (var model in models) {
      model.addListener(() => onModelChangeListener(model));
    }
  }

  /// **实现局部刷新的核心代码**
  /// 
  void onModelChangeListener(ChangeNotifier model) {
    if (MProvider._consumerContexts.containsKey(model)) {
      final _contexts = MProvider._consumerContexts[model];

      for (var _context in _contexts) {
        final _element = _context as Element;
        _element.markNeedsBuild();
      }
    }
  }

  void clean(List<ChangeNotifier> models) {
    for (final model in models) {
      MProvider._consumerContexts.remove(model);
      model.dispose();
    }
    models.clear();
    models = null;
  }
}

/// InherritedWidget
/// -----------------------------------------------------
/// 
class _MProviderInheritedWidget extends InheritedWidget {
  _MProviderInheritedWidget({
    this.models, 
    Widget child,
  }) : super(child: child);

  final List<ChangeNotifier> models;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// Consumer
/// -----------------------------------------------------
/// 
typedef _ConsumerCallback<T extends ChangeNotifier> = Widget Function(T model, Widget child);

class MConsumer<T extends ChangeNotifier> extends StatelessWidget {
  MConsumer({
    @required this.builder,
    this.child,
  });

  final Widget child;
  final _ConsumerCallback<T> builder;

  @override
  Widget build(BuildContext context) {
    final model = MProvider.get<T>(context);

    MProvider._buildRelationshipFor<T>(context, model);

    return builder(model, child);
  }
}

/// Consumer2
/// -----------------------------------------------------
/// 
typedef _Consumer2Callback<T1 extends ChangeNotifier,
                           T2 extends ChangeNotifier> = Widget Function(T1 model1, T2 model2, Widget child);
  
class MConsumer2<T1 extends ChangeNotifier, 
                 T2 extends ChangeNotifier> extends StatelessWidget {
  MConsumer2({
    @required this.builder,
    this.child,
  });

  final _Consumer2Callback<T1, T2> builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final model1 = MProvider.get<T1>(context);
    final model2 = MProvider.get<T2>(context);

    MProvider._buildRelationshipFor<T1>(context, model1);
    MProvider._buildRelationshipFor<T2>(context, model2);

    return builder(model1, model2, child);
  }
}

/// Consumer3
/// -----------------------------------------------------
/// 
typedef _Consumer3Callback<T1 extends ChangeNotifier,
                           T2 extends ChangeNotifier,
                           T3 extends ChangeNotifier> = Widget Function(T1 model1, T2 model2, T3 model3, Widget child);
  
class MConsumer3<T1 extends ChangeNotifier, 
                 T2 extends ChangeNotifier,
                 T3 extends ChangeNotifier> extends StatelessWidget {
  MConsumer3({
    @required this.builder,
    this.child,
  });

  final _Consumer3Callback<T1, T2, T3> builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final model1 = MProvider.get<T1>(context);
    final model2 = MProvider.get<T2>(context);
    final model3 = MProvider.get<T3>(context);

    MProvider._buildRelationshipFor<T1>(context, model1);
    MProvider._buildRelationshipFor<T2>(context, model2);
    MProvider._buildRelationshipFor<T3>(context, model3);

    return builder(model1, model2, model3, child);
  }
}

/// Consumer4
/// -----------------------------------------------------
/// 
typedef _Consumer4Callback<T1 extends ChangeNotifier,
                           T2 extends ChangeNotifier,
                           T3 extends ChangeNotifier,
                           T4 extends ChangeNotifier> = Widget Function(T1 model1, T2 model2, T3 model3, T4 model4, Widget child);

class MConsumer4<T1 extends ChangeNotifier, 
                 T2 extends ChangeNotifier,
                 T3 extends ChangeNotifier,
                 T4 extends ChangeNotifier> extends StatelessWidget {
  MConsumer4({
    @required this.builder,
    this.child,
  });

  final _Consumer4Callback<T1, T2, T3, T4> builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final model1 = MProvider.get<T1>(context);
    final model2 = MProvider.get<T2>(context);
    final model3 = MProvider.get<T3>(context);
    final model4 = MProvider.get<T4>(context);

    MProvider._buildRelationshipFor<T1>(context, model1);
    MProvider._buildRelationshipFor<T2>(context, model2);
    MProvider._buildRelationshipFor<T3>(context, model3);
    MProvider._buildRelationshipFor<T4>(context, model4);

    return builder(model1, model2, model3, model4, child);
  }
}

/// Consumer5
/// -----------------------------------------------------
/// 
typedef _Consumer5Callback<T1 extends ChangeNotifier,
                           T2 extends ChangeNotifier,
                           T3 extends ChangeNotifier,
                           T4 extends ChangeNotifier,
                           T5 extends ChangeNotifier> = Widget Function(T1 model1, T2 model2, T3 model3, T4 model4, T5 model5, Widget child);

class MConsumer5<T1 extends ChangeNotifier, 
                 T2 extends ChangeNotifier,
                 T3 extends ChangeNotifier,
                 T4 extends ChangeNotifier,
                 T5 extends ChangeNotifier> extends StatelessWidget {
  MConsumer5({
    @required this.builder,
    this.child,
  });

  final _Consumer5Callback<T1, T2, T3, T4, T5> builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final model1 = MProvider.get<T1>(context);
    final model2 = MProvider.get<T2>(context);
    final model3 = MProvider.get<T3>(context);
    final model4 = MProvider.get<T4>(context);
    final model5 = MProvider.get<T5>(context);

    MProvider._buildRelationshipFor<T1>(context, model1);
    MProvider._buildRelationshipFor<T2>(context, model2);
    MProvider._buildRelationshipFor<T3>(context, model3);
    MProvider._buildRelationshipFor<T4>(context, model4);
    MProvider._buildRelationshipFor<T5>(context, model5);

    return builder(model1, model2, model3, model4, model5, child);
  }
}
