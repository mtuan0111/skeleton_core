import re

file_path = '/Volumes/DATA/BOM_DATA/flutter_projects/skeleton_core/lib/src/helpers/app_text_styles.dart'

with open(file_path, 'r') as f:
    content = f.read()

# Add enum at the top if it doesn't exist
if 'enum AppFontType' not in content:
    content = content.replace('class AppTextStyles {', '''enum AppFontType { primary, secondary, handwriting }

class AppTextStyles {''')

# Add _getFontFamily helper
if '_getFontFamily' not in content:
    helper = '''
  static String? _getFontFamily(AppFontType? type) {
    if (type == null) return null;
    switch (type) {
      case AppFontType.primary:
        return SkeletonConfig.primaryFontFamily;
      case AppFontType.secondary:
        return SkeletonConfig.secondaryFontFamily;
      case AppFontType.handwriting:
        return SkeletonConfig.handwritingFontFamily;
    }
  }
'''
    content = content.replace('AppTextStyles._(); // Private constructor to prevent instantiation', 'AppTextStyles._(); // Private constructor to prevent instantiation\n' + helper)

def replace_method(match):
    name = match.group(1)
    args = match.group(2)
    body = match.group(3)
    
    # Determine default font type based on name
    if name.startswith('display') or name.startswith('headline') or name == 'forChallenge' or name == 'forCountdown':
        default_type = 'AppFontType.primary'
    elif name.startswith('handwriting'):
        default_type = 'AppFontType.handwriting'
    else:
        default_type = 'AppFontType.secondary'
        
    # Update args to include fontType
    if '[Color? backgroundColor]' in args:
        new_args = args.replace('[Color? backgroundColor]', f'[Color? backgroundColor, AppFontType fontType = {default_type}]')
    elif 'BuildContext context' in args and 'backgroundColor' not in args:
        new_args = args.replace('BuildContext context', f'BuildContext context, [AppFontType fontType = {default_type}]')
    else:
        new_args = args
        
    # If the method calls another method (like titleLargeBold calling titleLarge)
    # we need to pass fontType
    if body.strip().startswith('return ' + name.replace('Bold', '').replace('Italic', '').replace('Medium', '').replace('Light', '').replace('Secondary', '').replace('WithShadow', '').replace('TitleScreen', '').replace('OnDialogBackground', '').replace('BoldOnDialogBackground', 'Bold')):
        # It's calling a base method
        base_method = name.replace('Bold', '').replace('Italic', '').replace('Medium', '').replace('Light', '').replace('Secondary', '').replace('WithShadow', '').replace('TitleScreen', '').replace('OnDialogBackground', '').replace('BoldOnDialogBackground', 'Bold')
        if base_method in body and base_method != name:
            body = body.replace(f'{base_method}(context, backgroundColor)', f'{base_method}(context, backgroundColor, fontType)')
            body = body.replace(f'{base_method}(context)', f'{base_method}(context, null, fontType)')
            
    # Add fontFamily to copyWith if it's a direct copyWith call
    if '.textTheme.' in body and '.copyWith(' in body:
        if 'fontFamily:' not in body:
            body = body.replace('.copyWith(', '.copyWith(\n          fontFamily: _getFontFamily(fontType) ?? SkeletonConfig.primaryFontFamily,')
            if default_type == 'AppFontType.secondary':
                 body = body.replace('SkeletonConfig.primaryFontFamily', 'SkeletonConfig.secondaryFontFamily')
        else:
            # Replace existing fontFamily assignment
            body = re.sub(r'fontFamily:\s*[^,]+,', f'fontFamily: _getFontFamily(fontType),', body)

    return f'static TextStyle {name}({new_args}) {{{body}}}'

# We need a more careful regex to match methods
pattern = r'static TextStyle ([a-zA-Z0-9_]+)\(([^)]+)\)\s*\{([^}]+)\}'
content = re.sub(pattern, replace_method, content)

with open(file_path, 'w') as f:
    f.write(content)
