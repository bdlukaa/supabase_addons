<div>
  <h1 align="center">supabase_flutter_addons</h1>
  <p align="center" >
    <a title="Discord" href="https://discord.gg/674gpDQUVq">
      <img src="https://img.shields.io/discord/809528329337962516?label=discord&logo=discord" />
    </a>
    <a title="Pub" href="https://pub.dartlang.org/packages/supabase_flutter_addons" >
      <img src="https://img.shields.io/pub/v/supabase_flutter_addons.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github License">
      <img src="https://img.shields.io/github/license/bdlukaa/supabase_addons/supabase_flutter_addons" />
    </a>
    <a title="PRs are welcome">
      <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    </a>
  </p>
  <p align="center">
  Make great apps with a great backend!
  </p>
</div>

## Installation

Add the dependencies:

```yaml
dependencies:
  supabase: <latest-version>
  supabase_addons: <latest-version>
  supabase_flutter_addons: <latest-version>
```

and import the packages:

```dart
import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';
import 'package:supabase_flutter_addons/supabase_flutter_addons.dart';
```

## Get started

Initialize the addons.

```dart
await SupabaseAddonsFlutter.initialize(
  client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
);
```

And you're good to go!

Refer to [supabase_addons](https://github.com/bdlukaa/supabase_addons/tree/master/supabase_addons) documentation to learn more.

> You don't need to call `SupabaseAddons.initialize` if you already called `SupabaseAddonsFlutter.initialize`

To dispose the addons, call

```dart
SupabaseAddons.dispose();
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/bdlukaa/supabase_addons/issues/new
