import { createBrowserRouter, Outlet } from 'react-router-dom'

import App from '@/app/index'
import { ErrorBoundary } from '@/app/providers/ErrorBoundary'

function RootLayout() {
  return (
    <ErrorBoundary>
      <Outlet />
    </ErrorBoundary>
  )
}

// TODO: once pages/ and the AuthLayout/AppLayout providers exist, split this
// into the documented /auth and /app branches with lazy-loaded feature pages,
// e.g. { path: '/profile', lazy: () => import('@/pages/profile') }.
export const router = createBrowserRouter([
  {
    path: '/',
    element: <RootLayout />,
    children: [{ index: true, element: <App /> }],
  },
])
