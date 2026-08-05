import { Component, type ErrorInfo, type ReactNode } from 'react'

interface ErrorBoundaryProps {
  children: ReactNode
  fallback?: ReactNode
}

interface ErrorBoundaryState {
  hasError: boolean
}

/**
 * Global boundary mounted in app/providers. Catches whatever slips past
 * per-feature error boundaries so a crash in one part of the tree doesn't
 * take down the whole Mini App.
 */
export class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  state: ErrorBoundaryState = { hasError: false }

  static getDerivedStateFromError(): ErrorBoundaryState {
    return { hasError: true }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    if (import.meta.env.DEV) {
      console.error(error.message, error.stack, info.componentStack)
      return
    }

    sendErrorToExternalService(error, info)
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? <ErrorBoundaryFallback />
    }

    return this.props.children
  }
}

function ErrorBoundaryFallback() {
  return (
    <div role="alert">
      <p>Что-то пошло не так. Попробуйте перезагрузить приложение.</p>
    </div>
  )
}

function sendErrorToExternalService(error: Error, info: ErrorInfo) {
  // Placeholder until an external error-reporting service (Sentry or similar)
  // is wired up for production builds.
  void error
  void info
}
