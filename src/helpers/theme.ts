import { CapfaceSdkProps } from '..';
import { convertToHexColor } from './colors';

function formatColorToHexColor(color?: any): string | undefined {
  if (typeof color === 'string') {
    const hexColor = convertToHexColor(color);
    if (hexColor) return hexColor;
  }
  return undefined;
}

function formatColorsToHexColors(colors?: any[]): string[] | undefined {
  if (Array.isArray(colors)) {
    const hexColors = colors.map((color) => convertToHexColor(color) || '');
    const everyColorsExists = hexColors.every((color) => !!color);
    if (everyColorsExists) return hexColors;
  }
  return undefined;
}

function formatFeedbackBackgroundIos(
  background: CapfaceSdkProps.FeedbackBackgroundColor
): CapfaceSdkProps.FeedbackBackgroundColor | undefined {
  if (background) {
    background.colors = formatColorsToHexColors(background.colors);
  }
  return background;
}

export function convertThemePropsToHexColor(
  theme?: CapfaceSdkProps.Theme
): CapfaceSdkProps.Theme | undefined {
  if (theme) {
    if (theme?.feedbackBackgroundColorsIos) {
      theme.feedbackBackgroundColorsIos = formatFeedbackBackgroundIos(
        theme.feedbackBackgroundColorsIos
      );
    }

    for (const property in theme) {
      const option = property as keyof CapfaceSdkProps.Theme;
      const isImageProperty =
        option === 'cancelImage' || option === 'logoImage';
      if (typeof theme[option] === 'string' && !isImageProperty) {
        theme = Object.assign(theme, {
          [option]: formatColorToHexColor(theme[option]),
        });
      }
      if (Array.isArray(theme[option])) {
        theme = Object.assign(theme, {
          [option]: formatColorsToHexColors(theme[option] as any[]),
        });
      }
    }

    return theme;
  }

  return undefined;
}
