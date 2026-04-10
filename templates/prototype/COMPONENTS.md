# UI 组件库规范

本目录包含生成 HTML 原型所需的标准 UI 组件模板，基于 **TailwindCSS** 实用优先框架。

## 组件列表

### 基础组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Button` | 按钮组件 | 操作触发 |
| `Input` | 输入框组件 | 文本输入 |
| `Select` | 下拉选择器 | 单选/多选 |
| `Checkbox` | 复选框 | 多选开关 |
| `Radio` | 单选框 | 单选开关 |
| `Textarea` | 多行文本框 | 长文本输入 |
| `Switch` | 开关组件 | 二元状态切换 |

### 布局组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Container` | 页面容器 | 页面主体包裹 |
| `Grid` | 网格布局 | 卡片排列、数据展示 |
| `Flex` | 弹性布局 | 水平/垂直排列 |
| `Card` | 卡片容器 | 内容分组展示 |
| `Divider` | 分割线 | 内容分隔 |

### 导航组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Navbar` | 顶部导航栏 | 页面主导航 |
| `Sidebar` | 侧边栏 | 功能导航、目录 |
| `Tabs` | 标签页 | 内容分类切换 |
| `Breadcrumb` | 面包屑 | 层级导航 |
| `Pagination` | 分页器 | 列表分页 |

### 数据展示组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Table` | 表格 | 数据列表展示 |
| `List` | 列表 | 简单条目展示 |
| `Avatar` | 头像 | 用户展示 |
| `Badge` | 徽章 | 状态标记、计数 |
| `Tag` | 标签 | 分类标记 |
| `Progress` | 进度条 | 进度展示 |
| `Stat` | 统计卡片 | 指标展示 |

### 反馈组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Modal` | 模态框 | 重要操作确认 |
| `Toast` | 轻提示 | 操作结果反馈 |
| `Alert` | 警告提示 | 重要信息提示 |
| `Loading` | 加载动画 | 异步操作等待 |
| `Skeleton` | 骨架屏 | 内容加载占位 |

### 表单组件

| 组件 | 说明 | 使用场景 |
|:-----|:-----|:---------|
| `Form` | 表单容器 | 表单整体包裹 |
| `FormGroup` | 表单项 | 标签 + 输入组合 |
| `FormError` | 错误提示 | 输入校验错误 |
| `DatePicker` | 日期选择器 | 日期输入 |
| `FileUpload` | 文件上传 | 文件选择上传 |

---

## 组件使用示例

### Button 组件

```html
<!-- 主要按钮 -->
<button class="px-4 py-2.5 text-sm font-medium text-white bg-primary-600 rounded-lg hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-colors shadow-sm">
    主要操作
</button>

<!-- 次要按钮 -->
<button class="px-4 py-2.5 text-sm font-medium text-slate-700 bg-white border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors">
    取消
</button>

<!-- 危险按钮 -->
<button class="px-4 py-2.5 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500/20 transition-colors">
    删除
</button>

<!-- 图标按钮 -->
<button class="p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-colors">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">...</svg>
</button>

<!-- 禁用状态 -->
<button disabled class="px-4 py-2.5 text-sm font-medium text-slate-400 bg-slate-100 rounded-lg cursor-not-allowed">
    加载中...
</button>
```

### Card 组件

```html
<div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-md transition-shadow">
    <div class="px-6 py-4 border-b border-slate-200">
        <h3 class="text-lg font-semibold text-slate-900">卡片标题</h3>
    </div>
    <div class="p-6">
        卡片内容
    </div>
    <div class="px-6 py-4 border-t border-slate-200 bg-slate-50">
        卡片底部
    </div>
</div>
```

### Modal 组件

```html
<div id="modal" class="fixed inset-0 z-50 hidden">
    <!-- 遮罩层 -->
    <div class="fixed inset-0 bg-black/50 backdrop-blur-sm" onclick="closeModal()"></div>
    <!-- 内容 -->
    <div class="fixed inset-0 flex items-center justify-center p-4">
        <div class="relative bg-white rounded-xl shadow-xl max-w-lg w-full max-h-[80vh] overflow-y-auto animate-scale-in">
            <div class="px-6 py-4 border-b border-slate-200 flex items-center justify-between">
                <h3 class="text-lg font-semibold text-slate-900">标题</h3>
                <button onclick="closeModal()" class="p-1.5 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <div class="p-6">内容</div>
            <div class="px-6 py-4 border-t border-slate-200 flex justify-end gap-3">
                <button class="px-4 py-2 text-sm font-medium text-slate-700 bg-white border border-slate-200 rounded-lg hover:bg-slate-50">取消</button>
                <button class="px-4 py-2 text-sm font-medium text-white bg-primary-600 rounded-lg hover:bg-primary-700">确定</button>
            </div>
        </div>
    </div>
</div>
```

### Table 组件

```html
<div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
    <table class="w-full">
        <thead class="bg-slate-50 border-b border-slate-200">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">列 1</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">列 2</th>
                <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">操作</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-100">
            <tr class="hover:bg-slate-50 transition-colors">
                <td class="px-6 py-4 text-sm text-slate-900">数据 1</td>
                <td class="px-6 py-4 text-sm text-slate-500">数据 2</td>
                <td class="px-6 py-4 text-right">
                    <button class="text-sm font-medium text-primary-600 hover:text-primary-700">编辑</button>
                    <button class="ml-3 text-sm font-medium text-red-600 hover:text-red-700">删除</button>
                </td>
            </tr>
        </tbody>
    </table>
</div>
```

### Stat 统计卡片

```html
<div class="bg-white rounded-xl shadow-sm border border-slate-200 p-5 hover:shadow-md transition-shadow">
    <div class="flex items-center justify-between mb-4">
        <h3 class="text-sm font-medium text-slate-500">指标名称</h3>
        <span class="p-2 bg-primary-50 rounded-lg">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">...</svg>
        </span>
    </div>
    <p class="text-3xl font-bold text-slate-900 mb-1">1,234</p>
    <p class="text-sm text-emerald-600 font-medium">
        ↑ 12% <span class="text-slate-400 font-normal">较上月</span>
    </p>
</div>
```

### Progress 进度条

```html
<div>
    <div class="flex items-center justify-between text-sm mb-1">
        <span class="text-slate-500">进度</span>
        <span class="font-medium text-slate-700">75%</span>
    </div>
    <div class="h-2 bg-slate-100 rounded-full overflow-hidden">
        <div class="h-full bg-primary-500 rounded-full transition-all duration-500" style="width: 75%"></div>
    </div>
</div>
```

### Switch 开关

```html
<label class="relative inline-flex items-center cursor-pointer">
    <input type="checkbox" class="sr-only peer">
    <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
</label>
```

### Avatar 头像

```html
<!-- 单个头像 -->
<div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center text-white font-medium">
    张
</div>

<!-- 头像组 -->
<div class="flex -space-x-2">
    <div class="w-8 h-8 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 border-2 border-white flex items-center justify-center text-white text-xs">张</div>
    <div class="w-8 h-8 rounded-full bg-gradient-to-br from-emerald-400 to-emerald-600 border-2 border-white flex items-center justify-center text-white text-xs">李</div>
    <div class="w-8 h-8 rounded-full bg-slate-200 border-2 border-white flex items-center justify-center text-slate-500 text-xs">+3</div>
</div>
```

### Badge / Tag 徽章标签

```html
<!-- 状态徽章 -->
<span class="inline-flex px-2.5 py-1 text-xs font-medium rounded-md bg-emerald-50 text-emerald-700">已完成</span>
<span class="inline-flex px-2.5 py-1 text-xs font-medium rounded-md bg-blue-50 text-blue-700">进行中</span>
<span class="inline-flex px-2.5 py-1 text-xs font-medium rounded-md bg-amber-50 text-amber-700">待审核</span>
<span class="inline-flex px-2.5 py-1 text-xs font-medium rounded-md bg-red-50 text-red-700">已延期</span>

<!-- 圆点徽章（用于通知） -->
<span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
```

### Input 输入框

```html
<div class="relative">
    <label class="block text-sm font-medium text-slate-700 mb-1">标签名</label>
    <input type="text" placeholder="请输入..." class="w-full px-4 py-2.5 text-slate-900 placeholder-slate-400 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all">
    <p class="mt-1 text-xs text-slate-500">辅助说明文字</p>
</div>

<!-- 带图标的输入框 -->
<div class="relative">
    <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
    </svg>
    <input type="text" placeholder="搜索..." class="w-full pl-10 pr-4 py-2.5 text-slate-900 placeholder-slate-400 bg-slate-50 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all">
</div>

<!-- 错误状态 -->
<input type="text" class="w-full px-4 py-2.5 text-red-900 placeholder-red-300 bg-red-50 border border-red-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500/20">
<p class="mt-1 text-xs text-red-600">请输入有效的邮箱地址</p>
```

---

## 设计系统变量

### TailwindCSS 主题配置

```javascript
tailwind.config = {
    theme: {
        extend: {
            colors: {
                // 自定义主色
                primary: {
                    50: '#f0f9ff',
                    100: '#e0f2fe',
                    200: '#bae6fd',
                    300: '#7dd3fc',
                    400: '#38bdf8',
                    500: '#0ea5e9',
                    600: '#0284c7',
                    700: '#0369a1',
                    800: '#075985',
                    900: '#0c4a6e',
                },
                secondary: {
                    50: '#f8fafc',
                    500: '#64748b',
                    600: '#475569',
                    700: '#334155',
                }
            },
            animation: {
                'fade-in': 'fadeIn 0.3s ease-out',
                'slide-in': 'slideIn 0.3s ease-out',
                'scale-in': 'scaleIn 0.2s ease-out',
            },
            keyframes: {
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                slideIn: {
                    '0%': { transform: 'translateY(-10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
                scaleIn: {
                    '0%': { transform: 'scale(0.95)', opacity: '0' },
                    '100%': { transform: 'scale(1)', opacity: '1' },
                },
            }
        }
    }
}
```

### 颜色映射表

| 用途 | Tailwind 类 | 说明 |
|:-----|:-----------|:-----|
| 主色 | `bg-primary-600`, `text-primary-600` | 品牌色、主要操作 |
| 文字主色 | `text-slate-900` | 标题、重要文字 |
| 文字次要 | `text-slate-500`, `text-slate-600` | 描述、辅助文字 |
| 成功 | `text-emerald-600`, `bg-emerald-50` | 正向反馈 |
| 警告 | `text-amber-600`, `bg-amber-50` | 注意提示 |
| 错误 | `text-red-600`, `bg-red-50` | 错误、危险操作 |
| 背景 | `bg-slate-50` | 页面底色 |
| 边框 | `border-slate-200` | 分割线、卡片边框 |

### 间距系统（Tailwind 内置）

| 类名 | 值 | 用途 |
|:-----|:---|:-----|
| `p-1` ~ `p-2` | 4~8px | 紧凑内边距 |
| `p-3` ~ `p-4` | 12~16px | 常规内边距 |
| `p-5` ~ `p-6` | 20~24px | 卡片内边距 |
| `p-8` | 32px | 大容器内边距 |
| `gap-3` ~ `gap-6` | 12~24px | 网格间距 |
| `space-y-3` ~ `space-y-6` | 12~24px | 垂直间距 |

### 圆角系统（Tailwind 内置）

| 类名 | 值 | 用途 |
|:-----|:---|:-----|
| `rounded` | 3px | 小元素圆角 |
| `rounded-md` | 6px | 按钮、输入框 |
| `rounded-lg` | 8px | 常用圆角 |
| `rounded-xl` | 12px | 卡片、弹窗 |
| `rounded-full` | 9999px | 头像、徽章 |

### 阴影系统（Tailwind 内置）

| 类名 | 用途 |
|:-----|:-----|
| `shadow-sm` | 卡片默认阴影 |
| `shadow-md` | 悬停状态 |
| `shadow-lg` | 下拉菜单 |
| `shadow-xl` | 弹窗、抽屉 |

---

## 响应式断点

TailwindCSS 内置断点，使用 `sm:`, `md:`, `lg:`, `xl:` 前缀：

```html
<!-- 移动端优先 -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
<!-- 响应式文字 -->
<h1 class="text-xl md:text-2xl lg:text-3xl">标题</h1>
<!-- 响应式内边距 -->
<div class="p-4 md:p-6 lg:p-8">内容</div>
<!-- 响应式显隐 -->
<div class="hidden md:block">桌面端显示</div>
<div class="md:hidden">仅移动端显示</div>
```

| 前缀 | 断点 | 设备 |
|:-----|:-----|:-----|
| `sm:` | 640px | 大手机 |
| `md:` | 768px | 平板 |
| `lg:` | 1024px | 小笔记本 |
| `xl:` | 1280px | 桌面 |

---

## 可访问性标准

### ARIA 标签

```html
<!-- 按钮 -->
<button aria-label="关闭对话框">
    <svg class="w-5 h-5" ...></svg>
</button>

<!-- 导航 -->
<nav aria-label="主导航">...</nav>

<!-- 表单错误 -->
<input aria-invalid="true" aria-describedby="error-msg">
<p id="error-msg" role="alert" class="text-xs text-red-600">输入有误</p>
```

### 键盘导航

```html
<!-- 焦点环 -->
<button class="focus:outline-none focus:ring-2 focus:ring-primary-500/20">
    可聚焦按钮
</button>
```

---

## 质量检查清单

生成原型前检查：

- [ ] 使用语义化 HTML 标签（header, nav, main, section, footer）
- [ ] 包含 viewport meta 标签和 TailwindCDN 引入
- [ ] 所有交互元素有 focus 状态样式
- [ ] 颜色对比度符合 WCAG AA 标准
- [ ] 表单元素有关联的 label
- [ ] 图片/icon 有 alt 或 aria-label 文本
- [ ] 响应式布局适配移动端（sm/md/lg）
- [ ] 加载状态有视觉反馈
- [ ] 错误信息清晰可读
- [ ] 按钮文案描述操作结果
