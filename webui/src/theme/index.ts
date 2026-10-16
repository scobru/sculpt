// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 Jun Murakami
import { createTheme } from '@mui/material/styles';
import '@fontsource/red-hat-mono/400.css';
import '@fontsource/jost/400.css';
import '@fontsource/jost/600.css';
import '@fontsource/jost/700.css';

export const darkTheme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#00d2ff',
      light: '#6ae7ff',
      dark: '#0099cc',
    },
    secondary: {
      main: '#ff9f1c',
      light: '#ffb74d',
      dark: '#f57c00',
    },
    background: {
      default: '#090c12',
      paper: '#12151f',
    },
    text: {
      primary: '#f8fafc',
      secondary: '#94a3b8',
    },
    divider: '#222938',
  },
  typography: {
    fontFamily: '"Jost",-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    h6: {
      fontSize: '1.1rem',
      fontWeight: 500,
    },
  },
  shape: {
    borderRadius: 8,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: 'none',
          fontWeight: 500,
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
        },
      },
    },
    MuiSlider: {
      styleOverrides: {
        root: {
          height: 4,
          '& .MuiSlider-thumb': {
            width: 16,
            height: 16,
            '&:hover': {
              boxShadow: '0px 0px 0px 8px rgba(79, 195, 247, 0.16)',
            },
          },
          '& .MuiSlider-rail': {
            opacity: 0.3,
          },
        },
      },
    },
  },
});