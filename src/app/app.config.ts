import {ApplicationConfig, provideExperimentalZonelessChangeDetection} from '@angular/core';
import {provideRouter} from '@angular/router';
import {routes} from './app.routes';
import {provideHttpClient, withFetch} from '@angular/common/http';
import {provideAnimationsAsync} from '@angular/platform-browser/animations/async';
import {definePreset} from '@primeng/themes';
import {providePrimeNG} from 'primeng/config';
import Aura from "@primeng/themes/aura";
import {MessageService} from 'primeng/api';

const Noir = definePreset(Aura, {
  semantic: {
    primary: {
      50: '{zinc.50}',
      100: '{zinc.100}',
      200: '{zinc.200}',
      300: '{zinc.300}',
      400: '{zinc.400}',
      500: '{zinc.500}',
      600: '{zinc.600}',
      700: '{zinc.700}',
      800: '{zinc.800}',
      900: '{zinc.900}',
      950: '{zinc.950}'
    },
    colorScheme: {
      light: {
        primary: {
          color: '{zinc.950}',
          inverseColor: '#ffffff',
          hoverColor: '{zinc.900}',
          activeColor: '{zinc.800}'
        },
        highlight: {
          background: '{zinc.950}',
          focusBackground: '{zinc.700}',
          color: '#ffffff',
          focusColor: '#ffffff'
        }
      },
      dark: {
        primary: {
          color: '{zinc.50}',
          inverseColor: '{zinc.950}',
          hoverColor: '{zinc.100}',
          activeColor: '{zinc.200}'
        },
        highlight: {
          background: 'rgba(250, 250, 250, .16)',
          focusBackground: 'rgba(250, 250, 250, .24)',
          color: 'rgba(255,255,255,.87)',
          focusColor: 'rgba(255,255,255,.87)'
        }
      }
    }
  }
});

export const appConfig: ApplicationConfig = {
  providers: [
    MessageService,
    provideExperimentalZonelessChangeDetection(),
    provideRouter(routes),
    provideHttpClient(withFetch()),
    provideAnimationsAsync(),
    providePrimeNG({
      ripple: true,
      theme: {
        preset: Noir,
        options: {
          cssLayer: {
            name: 'primeng',
            order: 'tailwind-base, primeng, tailwind-utilities',
          }
        }
      }
    }),
  ]
};
