"""Configure Flutter-generated Android scaffold with Nivora branding.
Run after `flutter create --platforms=android .`.
Only Python standard library is used.
"""
from pathlib import Path
import shutil
import re

root = Path(__file__).resolve().parents[1]
app = root / 'android' / 'app' / 'src' / 'main'
manifest = app / 'AndroidManifest.xml'
if not manifest.exists():
    raise SystemExit('Generate the Android scaffold first: flutter create --platforms=android .')

xml = manifest.read_text()
xml = re.sub(r'android:label="[^"]*"', 'android:label="Nivora Booking"', xml, count=1)
if 'android.permission.INTERNET' not in xml:
    xml = re.sub(r'(<manifest\b[^>]*>)', r'\1\n    <uses-permission android:name="android.permission.INTERNET" />', xml, count=1)
manifest.write_text(xml)

for density in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']:
    source = root / 'assets' / 'branding' / f'mipmap-{density}' / 'ic_launcher.png'
    target = app / 'res' / f'mipmap-{density}' / 'ic_launcher.png'
    if source.exists():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)

print('Nivora Android app label, internet permission, and icons configured.')
