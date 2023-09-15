import { convertThemePropsToHexColor } from '.';
import { CapfaceSdkProps } from '..';

const HEX_COLOR = '#00FFC8';
const HEX_ALPHA_COLOR = '#00FFC8B3';
const RGB_COLOR = 'rgb(0,255,200)';
const RGBA_COLOR = 'rgba(0,255,200,0.7)';
const HSL_COLOR = 'hsl(167, 100%, 50%)';
const HSLA_COLOR = 'hsla(167, 100%, 50%, 0.7)';

const createTestTheme = (color: string): CapfaceSdkProps.Theme => ({
  feedbackTextColor: color,
  feedbackBackgroundColorsIos: {
    colors: [color, color],
  },
  guidanceBackgroundColorsIos: [color, color],
});

describe('Themme Helper', () => {
  describe('Ensure convertThemePropsToHexColor function should', () => {
    describe('Works general', () => {
      it('Should be call with correct values', () => {
        const fn = { method: convertThemePropsToHexColor };
        jest.spyOn(fn, 'method');
        fn.method({});
        expect(fn.method).toHaveBeenCalledTimes(1);
        expect(fn.method).toHaveBeenCalledWith({});
      });
    });

    describe('Works with hexadecimal colors', () => {
      it('Should a return hexadecimal color if a object with hexadecimal colors is provided', () => {
        const theme = convertThemePropsToHexColor(createTestTheme(HEX_COLOR));
        expect(theme).toEqual(createTestTheme(HEX_COLOR));
      });
    });

    describe('Works with RGB colors', () => {
      it('Should a return RGB color if a object with RGB colors is provided', () => {
        const theme = convertThemePropsToHexColor(createTestTheme(RGB_COLOR));
        expect(theme).toEqual(createTestTheme(HEX_COLOR));
      });
    });

    describe('Works with RGBA colors', () => {
      it('Should a return RGBA color if a object with RGBA colors is provided', () => {
        const theme = convertThemePropsToHexColor(createTestTheme(RGBA_COLOR));
        expect(theme).toEqual(createTestTheme(HEX_ALPHA_COLOR));
      });
    });

    describe('Works with HSL colors', () => {
      it('Should a return HSL color if a object with HSL colors is provided', () => {
        const theme = convertThemePropsToHexColor(createTestTheme(HSL_COLOR));
        expect(theme).toEqual(createTestTheme(HEX_COLOR));
      });
    });

    describe('Works with HSLA colors', () => {
      it('Should a return HSLA color if a object with HSLA colors is provided', () => {
        const theme = convertThemePropsToHexColor(createTestTheme(HSLA_COLOR));
        expect(theme).toEqual(createTestTheme(HEX_ALPHA_COLOR));
      });
    });
  });
});
