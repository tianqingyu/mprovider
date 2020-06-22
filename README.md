超轻量级的Provider实现
---

Provider API:
---
1. MProvider(...)
2. MProvider.get()

Consumer API:
---
1. MConsumer(...)
2. MConsumer2(...)
3. MConsumer3(...)
4. MConsumer4(...)
5. MConsumer5(...)

注意：
---
MProvider建议使用多model形式，不要定义一个大而全的model，而是拆分成多个小model，
例如userModel，loginModel，photoModel，musicModel等，一个widget可以组合使用这些model

如何使用：
---
```
  MProvider(
    create: () => [
      ModelA(), 
      ModelB(),
    ],
    child: Column(
      children: [
        MConsumer<ModelA>(
          builder: (modelA, child) => Text('modelA'),
        ),
        MConsumer<ModelB>(
          builder: (modelB, child) => Text('modelB'),
        ),
      ],
    ),
  ),
```
