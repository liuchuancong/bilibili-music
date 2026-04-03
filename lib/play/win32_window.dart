import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class WinFullscreen {
  static int? _hwnd;
  static int _originalX = 0, _originalY = 0, _originalWidth = 800, _originalHeight = 600;
  static bool _originalMaximized = false, _originalSaved = false;

  static int _getHwnd() {
    _hwnd ??= GetForegroundWindow();
    return _hwnd!;
  }

  static void saveOriginalWindowRect() {
    if (!Platform.isWindows || _originalSaved) return;
    final hWnd = _getHwnd();
    _originalMaximized = IsZoomed(hWnd) != 0;
    final rect = calloc<RECT>();
    if (GetWindowRect(hWnd, rect) != 0) {
      _originalX = rect.ref.left;
      _originalY = rect.ref.top;
      _originalWidth = rect.ref.right - rect.ref.left;
      _originalHeight = rect.ref.bottom - rect.ref.top;
      _originalSaved = true;
    }
    calloc.free(rect);
  }

  static void enterFullscreen() {
    if (!Platform.isWindows) return;
    final hWnd = _getHwnd();
    saveOriginalWindowRect();

    // 1. 关键样式：WS_POPUP (弹出式窗口，无边框、无标题栏)
    int style = GetWindowLongPtr(hWnd, GWL_STYLE);
    style &= ~(WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU | WS_BORDER | WS_DLGFRAME);
    style |= WS_POPUP; // 必须加入此项，否则系统会预留边框空间
    SetWindowLongPtr(hWnd, GWL_STYLE, style);

    // 2. 清除所有扩展样式的边界
    int exStyle = GetWindowLongPtr(hWnd, GWL_EXSTYLE);
    exStyle &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);
    SetWindowLongPtr(hWnd, GWL_EXSTYLE, exStyle);

    // 3. 获取显示器完整尺寸 (包含任务栏区域)
    final monitor = MonitorFromWindow(hWnd, MONITOR_DEFAULTTONEAREST);
    final info = calloc<MONITORINFO>()..ref.cbSize = sizeOf<MONITORINFO>();
    GetMonitorInfo(monitor, info);

    // 4. 强制设置到 Monitor 坐标，不留任何余量
    double offset = 10;

    SetWindowPos(
      hWnd,
      HWND_TOP,
      info.ref.rcMonitor.left - offset.toInt(), // 左边往外扩
      info.ref.rcMonitor.top - offset.toInt(), // 顶边往外扩
      (info.ref.rcMonitor.right - info.ref.rcMonitor.left) + (offset * 2).toInt(), // 宽度补双倍，确保左右都出去
      (info.ref.rcMonitor.bottom - info.ref.rcMonitor.top) + (offset * 2).toInt(), // 高度补双倍，确保上下都出去
      SWP_SHOWWINDOW | SWP_FRAMECHANGED | SWP_NOZORDER,
    );

    // 5. 某些显卡驱动下需要强制刷新一次显示
    ShowWindow(hWnd, SW_NORMAL);

    calloc.free(info);
  }

  static void exitFullscreen() {
    if (!Platform.isWindows) return;
    final hWnd = _getHwnd();

    int style = GetWindowLongPtr(hWnd, GWL_STYLE);
    style &= ~WS_POPUP; // Remove Popup style
    style |= WS_CAPTION | WS_THICKFRAME | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
    SetWindowLongPtr(hWnd, GWL_STYLE, style);

    int exStyle = GetWindowLongPtr(hWnd, GWL_EXSTYLE);
    exStyle |= WS_EX_WINDOWEDGE;
    SetWindowLongPtr(hWnd, GWL_EXSTYLE, exStyle);

    if (_originalMaximized) {
      ShowWindow(hWnd, SW_MAXIMIZE);
    } else {
      SetWindowPos(hWnd, HWND_TOP, _originalX, _originalY, _originalWidth, _originalHeight,
          SWP_SHOWWINDOW | SWP_FRAMECHANGED | SWP_NOZORDER);
    }
    _originalSaved = false;
  }
}
