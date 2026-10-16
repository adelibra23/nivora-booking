"""Replace only the Flutter-generated stale MyApp test; keep real project tests."""
from pathlib import Path
import re
import shutil

project = Path(__file__).resolve().parents[1]
target = project / 'test' / 'widget_test.dart'
known_good = project / 'scripts' / 'ci_widget_test.dart'

if not known_good.is_file():
    raise SystemExit('Missing scripts/ci_widget_test.dart: commit all files from v1.0.2.')

if not target.is_file():
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(known_good, target)
    print('Restored absent Nivora widget test.')
elif re.search(r'\bMyApp\s*\(', target.read_text(encoding='utf-8')):
    shutil.copyfile(known_good, target)
    print('Replaced stale Flutter template test referring to MyApp().')
else:
    print('Existing Nivora widget test retained.')

source = target.read_text(encoding='utf-8')
if 'NivoraApp' not in source or re.search(r'\bMyApp\s*\(', source):
    raise SystemExit('Widget test is not compatible with NivoraApp.')
