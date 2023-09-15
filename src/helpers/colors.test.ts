import { convertToHexColor } from '.';

const MAX_HEX_ALPHA_COLOR = '#00FFC8B3';
const MAX_HEX_COLOR = '#00FFC8';
const MIN_HEX_ALPHA_COLOR = '#0FCB';
const MIN_HEX_COLOR = '#0FC';

describe('Colors Helper', () => {
  describe('Ensure convertToHexColor function should', () => {
    describe('Works general', () => {
      it('Should be call with correct values', () => {
        const fn = { method: convertToHexColor };
        jest.spyOn(fn, 'method');
        fn.method(MAX_HEX_COLOR);
        expect(fn.method).toHaveBeenCalledTimes(1);
        expect(fn.method).toHaveBeenCalledWith(MAX_HEX_COLOR);
      });

      it('Should return null if invalid values provided', () => {
        expect(convertToHexColor('')).toBeNull();
        expect(convertToHexColor(' ')).toBeNull();
        expect(convertToHexColor('invalid')).toBeNull();
        expect(convertToHexColor('1234567890')).toBeNull();
        expect(convertToHexColor('ABCDEFGHIJKLMNOPQRSTUVWXYZ')).toBeNull();
        expect(convertToHexColor('˜!@#$%ˆ&*()_+`-={}][;:"<>,./?')).toBeNull();
      });
    });

    describe('Works with hexadecimal colors', () => {
      it('Should a return hexadecimal color if a hexadecimal color is provided', () => {
        const maxHexCharacters = convertToHexColor(MAX_HEX_COLOR);
        const minHexCharacters = convertToHexColor(MIN_HEX_COLOR);
        const minHexAlphaCharacters = convertToHexColor(MIN_HEX_ALPHA_COLOR);
        const maxHexAlphaCharacters = convertToHexColor(MAX_HEX_ALPHA_COLOR);

        expect(minHexCharacters).toBe('#00FFCC');
        expect(maxHexCharacters).toBe(MAX_HEX_COLOR);
        expect(minHexAlphaCharacters).toBe('#00FFCCBB');
        expect(maxHexAlphaCharacters).toBe(MAX_HEX_ALPHA_COLOR);
      });

      it('Should return null if an invalid hexadecimal colors is provided', () => {
        expect(convertToHexColor('#')).toBeNull();
        expect(convertToHexColor('#0')).toBeNull();
        expect(convertToHexColor('#0')).toBeNull();
        expect(convertToHexColor('000')).toBeNull();
        expect(convertToHexColor('#XYZ')).toBeNull();
        expect(convertToHexColor('#XYZX')).toBeNull();
        expect(convertToHexColor('#00000')).toBeNull();
        expect(convertToHexColor('000000')).toBeNull();
        expect(convertToHexColor('#XYZXYZ')).toBeNull();
        expect(convertToHexColor('#0000000')).toBeNull();
        expect(convertToHexColor('00000000')).toBeNull();
        expect(convertToHexColor('#XYZXYZ00')).toBeNull();
        expect(convertToHexColor('#0000000000')).toBeNull();
        expect(convertToHexColor('#00000000000000000000000')).toBeNull();
      });
    });

    describe('Works with RGB colors', () => {
      it('Should a return RGB color if a hexadecimal color is provided', () => {
        const hexColor = convertToHexColor('rgb(0,255,200)');
        expect(hexColor).toBe(MAX_HEX_COLOR);
      });

      it('Should return null if an invalid RGB colors is provided', () => {
        expect(convertToHexColor('rgb')).toBeNull();
        expect(convertToHexColor('rgb()')).toBeNull();
        expect(convertToHexColor('rgb(0)')).toBeNull();
        expect(convertToHexColor('rgb(0,)')).toBeNull();
        expect(convertToHexColor('rgb(,,,)')).toBeNull();
        expect(convertToHexColor('rgb(0 0)')).toBeNull();
        expect(convertToHexColor('rgb(0-0)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0,)')).toBeNull();
        expect(convertToHexColor('rgb(0 0 0)')).toBeNull();
        expect(convertToHexColor('rgb(0-0-0)')).toBeNull();
        expect(convertToHexColor('rgb(=, +, -)')).toBeNull();
        expect(convertToHexColor('rgb(X, Y, Z)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0, -1)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0, 0,)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0, 256)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0, 0, 0)')).toBeNull();
        expect(convertToHexColor('rgb(-1, -1, -1)')).toBeNull();
        expect(convertToHexColor('rgb(256, 256, 256)')).toBeNull();
        expect(convertToHexColor('rgb(0, 0, 0, 0, 0)')).toBeNull();
      });
    });

    describe('Works with RGBA colors', () => {
      it('Should a return RGBA color if a hexadecimal color is provided', () => {
        const hexColor = convertToHexColor('rgba(0,255,200,0.7)');
        expect(hexColor).toBe(MAX_HEX_ALPHA_COLOR);
      });

      it('Should return null if an invalid RGBA colors is provided', () => {
        expect(convertToHexColor('rgba')).toBeNull();
        expect(convertToHexColor('rgba()')).toBeNull();
        expect(convertToHexColor('rgba(0)')).toBeNull();
        expect(convertToHexColor('rgba(0,)')).toBeNull();
        expect(convertToHexColor('rgba(0 0)')).toBeNull();
        expect(convertToHexColor('rgba(0-0)')).toBeNull();
        expect(convertToHexColor('rgba(,,,)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0,)')).toBeNull();
        expect(convertToHexColor('rgba(0 0 0)')).toBeNull();
        expect(convertToHexColor('rgba(0-0-0)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, -1)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, 0,)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, 256)')).toBeNull();
        expect(convertToHexColor('rgba(+, -, *, /)')).toBeNull();
        expect(convertToHexColor('rgba(X, Y, Z, A)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, 0, 2)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, 0, -1)')).toBeNull();
        expect(convertToHexColor('rgba(256, 256, 256)')).toBeNull();
        expect(convertToHexColor('rgba(0, 0, 0, 1, 0)')).toBeNull();
        expect(convertToHexColor('rgba(-1, -1, -1, -1)')).toBeNull();
      });
    });

    describe('Works with HSL colors', () => {
      it('Should a return HSL color if a hexadecimal color is provided', () => {
        expect(convertToHexColor('hsl(167, 100, 50)')).toBe(MAX_HEX_COLOR);
        expect(convertToHexColor('hsl(167, 100, 50%)')).toBe(MAX_HEX_COLOR);
        expect(convertToHexColor('hsl(167, 100%, 50)')).toBe(MAX_HEX_COLOR);
        expect(convertToHexColor('hsl(167, 100%, 50%)')).toBe(MAX_HEX_COLOR);
      });

      it('Should return null if an invalid HSL colors is provided', () => {
        expect(convertToHexColor('hsl')).toBeNull();
        expect(convertToHexColor('hsl()')).toBeNull();
        expect(convertToHexColor('hsl(0)')).toBeNull();
        expect(convertToHexColor('hsl(0,)')).toBeNull();
        expect(convertToHexColor('hsl(,,,)')).toBeNull();
        expect(convertToHexColor('hsl(0 0)')).toBeNull();
        expect(convertToHexColor('hsl(0-0)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%)')).toBeNull();
        expect(convertToHexColor('hsl(0-0-0)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%,)')).toBeNull();
        expect(convertToHexColor('hsl(=, +, -)')).toBeNull();
        expect(convertToHexColor('hsl(X, Y, Z)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%, -1)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%, 0%,)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%, -0%)')).toBeNull();
        expect(convertToHexColor('hsl(0, 101%, 0%)')).toBeNull();
        expect(convertToHexColor('hsl(-1, -1%, -1%)')).toBeNull();
        expect(convertToHexColor('hsl(0, 0%, 0%, 1, 0%)')).toBeNull();
      });
    });

    describe('Works with HSLA colors', () => {
      it('Should a return HSLA color if a hexadecimal color is provided', () => {
        expect(convertToHexColor('hsla(167, 100, 50, 0.7)')).toBe(
          MAX_HEX_ALPHA_COLOR
        );
        expect(convertToHexColor('hsla(167, 100%, 50%, 0.7)')).toBe(
          MAX_HEX_ALPHA_COLOR
        );
        expect(convertToHexColor('hsla(167, 100, 50%, 0.7)')).toBe(
          MAX_HEX_ALPHA_COLOR
        );
        expect(convertToHexColor('hsla(167, 100%, 50, 0.7)')).toBe(
          MAX_HEX_ALPHA_COLOR
        );
      });

      it('Should return null if an invalid HSLA colors is provided', () => {
        expect(convertToHexColor('hsla')).toBeNull();
        expect(convertToHexColor('hsla()')).toBeNull();
        expect(convertToHexColor('hsla(0)')).toBeNull();
        expect(convertToHexColor('hsla(0,)')).toBeNull();
        expect(convertToHexColor('hsla(,,,)')).toBeNull();
        expect(convertToHexColor('hsla(0 0)')).toBeNull();
        expect(convertToHexColor('hsla(0-0)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%)')).toBeNull();
        expect(convertToHexColor('hsla(0-0-0)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%,)')).toBeNull();
        expect(convertToHexColor('hsla(0-0-0-0)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, -1)')).toBeNull();
        expect(convertToHexColor('hsla(+, -, *, /)')).toBeNull();
        expect(convertToHexColor('hsla(X, Y, Z, A)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, -0%)')).toBeNull();
        expect(convertToHexColor('hsla(0, 101%, 0%)')).toBeNull();
        expect(convertToHexColor('hsla(-1, -1%, -1%)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, 101%,)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, 0%, 2)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, -0%, 1)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, 0%, -1)')).toBeNull();
        expect(convertToHexColor('hsla(0, 101%, 0%, 1)')).toBeNull();
        expect(convertToHexColor('hsla(0, 0%, 0%, 1, 0%)')).toBeNull();
        expect(convertToHexColor('hsla(-1, -1%, -1%, -1%)')).toBeNull();
      });
    });
  });
});
