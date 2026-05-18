"""
Smart Grocery Inventory - Mobile Application
Kivy mobile interface that reads grocery data from REST web services.
"""

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.scrollview import ScrollView
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.tabbedpanel import TabbedPanel, TabbedPanelItem
from kivy.core.window import Window
from kivy.graphics import Color, Rectangle
from kivy.metrics import dp
from kivy.clock import Clock

import urllib.request
import json
import threading

# Mobile window size
Window.size = (400, 700)

# Base URL for the REST web service
BASE_URL = "http://localhost:8080/SmartGroceryInventory/api"


class SmartGroceryMobile(App):
    def build(self):
        self.title = "Smart Grocery Mobile"
        Window.clearcolor = (0.94, 0.95, 0.96, 1)

        root = BoxLayout(orientation='vertical', spacing=0)

        # Header
        header = BoxLayout(size_hint_y=None, height=dp(65))
        with header.canvas.before:
            Color(0.176, 0.416, 0.310, 1)
            self._header_bg = Rectangle(pos=header.pos, size=header.size)
        header.bind(pos=self._update_bg, size=self._update_bg)

        header_label = Label(
            text="[b]Smart Grocery Inventory[/b]\n[size=12]Mobile Application[/size]",
            markup=True, font_size=dp(18), color=(1, 1, 1, 1), halign='center'
        )
        header.add_widget(header_label)
        root.add_widget(header)

        # Tabs
        tabs = TabbedPanel(do_default_tab=False, tab_width=dp(120), tab_height=dp(38))

        grocery_tab = TabbedPanelItem(text='Grocery Items')
        grocery_tab.add_widget(DataTab("groceryitems", self._format_grocery))
        tabs.add_widget(grocery_tab)

        supplier_tab = TabbedPanelItem(text='Suppliers')
        supplier_tab.add_widget(DataTab("suppliers", self._format_supplier))
        tabs.add_widget(supplier_tab)

        category_tab = TabbedPanelItem(text='Categories')
        category_tab.add_widget(DataTab("categories", self._format_category))
        tabs.add_widget(category_tab)

        root.add_widget(tabs)

        # Footer
        footer = BoxLayout(size_hint_y=None, height=dp(28))
        with footer.canvas.before:
            Color(0.85, 0.85, 0.85, 1)
            self._footer_bg = Rectangle(pos=footer.pos, size=footer.size)
        footer.bind(pos=self._update_footer, size=self._update_footer)
        footer.add_widget(Label(
            text="Smart Grocery Mobile v1.0",
            font_size=dp(10), color=(0.5, 0.5, 0.5, 1)
        ))
        root.add_widget(footer)

        return root

    def _update_bg(self, instance, value):
        self._header_bg.pos = instance.pos
        self._header_bg.size = instance.size

    def _update_footer(self, instance, value):
        self._footer_bg.pos = instance.pos
        self._footer_bg.size = instance.size

    def _format_grocery(self, item):
        return (
            f"[b][size=15]{item.get('itemName', 'N/A')}[/size][/b]\n"
            f"[color=#2d6a4f]Brand:[/color] {item.get('brand', 'N/A')}  |  "
            f"[color=#2d6a4f]Category:[/color] {item.get('category', 'N/A')}\n"
            f"[color=#2d6a4f]Qty:[/color] {item.get('quantity', 0)}  |  "
            f"[color=#2d6a4f]Price:[/color] ${item.get('price', 0):.2f}\n"
            f"[color=#2d6a4f]Expiry:[/color] {item.get('expiryDate', 'N/A')}  |  "
            f"[color=#2d6a4f]Supplier:[/color] {item.get('supplier', 'N/A')}"
        )

    def _format_supplier(self, item):
        return (
            f"[b][size=15]{item.get('supplierName', 'N/A')}[/size][/b]\n"
            f"[color=#0077b6]Contact:[/color] {item.get('contactPerson', 'N/A')}\n"
            f"[color=#0077b6]Email:[/color] {item.get('email', 'N/A')}\n"
            f"[color=#0077b6]Phone:[/color] {item.get('phone', 'N/A')}\n"
            f"[color=#0077b6]Products:[/color] {item.get('productsSupplied', 'N/A')}"
        )

    def _format_category(self, item):
        return (
            f"[b][size=15]{item.get('categoryName', 'N/A')}[/size][/b]\n"
            f"[color=#e76f51]Aisle:[/color] {item.get('aisleNumber', 'N/A')}  |  "
            f"[color=#e76f51]Storage:[/color] {item.get('storageType', 'N/A')}\n"
            f"[color=#e76f51]Shelf Life:[/color] {item.get('shelfLife', 'N/A')}  |  "
            f"[color=#e76f51]Perishable:[/color] {item.get('isPerishable', 'N/A')}\n"
            f"[color=#e76f51]Min Stock:[/color] {item.get('minStockLevel', 0)}"
        )


class DataTab(BoxLayout):
    """Reusable tab that loads and displays data from a REST endpoint."""

    def __init__(self, endpoint, formatter, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'vertical'
        self.padding = dp(10)
        self.spacing = dp(8)
        self.endpoint = endpoint
        self.formatter = formatter

        # Server URL
        url_row = BoxLayout(size_hint_y=None, height=dp(32), spacing=dp(5))
        url_row.add_widget(Label(
            text="Server:", size_hint_x=0.15, font_size=dp(11), color=(0.4, 0.4, 0.4, 1)
        ))
        self.url_input = TextInput(
            text=BASE_URL, multiline=False, font_size=dp(11),
            size_hint_x=0.85, padding=[dp(6), dp(6)]
        )
        url_row.add_widget(self.url_input)
        self.add_widget(url_row)

        # Buttons
        btn_row = BoxLayout(size_hint_y=None, height=dp(42), spacing=dp(8))

        load_btn = Button(
            text="Load All", font_size=dp(13), bold=True,
            background_color=(0.176, 0.416, 0.310, 1), color=(1, 1, 1, 1)
        )
        load_btn.bind(on_press=self.load_all)

        count_btn = Button(
            text="Get Count", font_size=dp(13), bold=True,
            background_color=(0, 0.467, 0.714, 1), color=(1, 1, 1, 1)
        )
        count_btn.bind(on_press=self.load_count)

        btn_row.add_widget(load_btn)
        btn_row.add_widget(count_btn)
        self.add_widget(btn_row)

        # Find by ID
        id_row = BoxLayout(size_hint_y=None, height=dp(35), spacing=dp(5))
        self.id_input = TextInput(
            hint_text="Enter ID...", multiline=False, input_filter='int',
            font_size=dp(12), size_hint_x=0.5, padding=[dp(6), dp(6)]
        )
        find_btn = Button(
            text="Find by ID", size_hint_x=0.5, font_size=dp(12), bold=True,
            background_color=(0.251, 0.569, 0.424, 1), color=(1, 1, 1, 1)
        )
        find_btn.bind(on_press=self.load_by_id)
        id_row.add_widget(self.id_input)
        id_row.add_widget(find_btn)
        self.add_widget(id_row)

        # Status
        self.status_label = Label(
            text='Tap "Load All" to fetch data from the web service',
            size_hint_y=None, height=dp(22), font_size=dp(11),
            color=(0.4, 0.4, 0.4, 1)
        )
        self.add_widget(self.status_label)

        # Scrollable results
        scroll = ScrollView()
        self.results = GridLayout(cols=1, spacing=dp(8), size_hint_y=None, padding=[0, dp(5)])
        self.results.bind(minimum_height=self.results.setter('height'))
        scroll.add_widget(self.results)
        self.add_widget(scroll)

    def _get_url(self, path=""):
        base = self.url_input.text.strip().rstrip('/')
        return f"{base}/{self.endpoint}{path}"

    def load_all(self, instance):
        self.status_label.text = "Loading..."
        self.status_label.color = (0, 0.467, 0.714, 1)
        threading.Thread(target=self._fetch, args=(self._get_url(), self._show_list), daemon=True).start()

    def load_count(self, instance):
        self.status_label.text = "Getting count..."
        threading.Thread(target=self._fetch, args=(self._get_url("/count"), self._show_count), daemon=True).start()

    def load_by_id(self, instance):
        item_id = self.id_input.text.strip()
        if not item_id:
            self.status_label.text = "Please enter an ID"
            self.status_label.color = (0.9, 0.2, 0.2, 1)
            return
        self.status_label.text = "Searching..."
        threading.Thread(target=self._fetch, args=(self._get_url(f"/{item_id}"), self._show_single), daemon=True).start()

    def _fetch(self, url, callback):
        try:
            req = urllib.request.Request(url)
            req.add_header('Accept', 'application/json')
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = resp.read().decode('utf-8')
            Clock.schedule_once(lambda dt: callback(data), 0)
        except Exception as e:
            Clock.schedule_once(lambda dt: self._show_error(str(e)), 0)

    def _show_error(self, msg):
        self.status_label.text = "Connection error"
        self.status_label.color = (0.9, 0.2, 0.2, 1)
        self.results.clear_widgets()
        self.results.add_widget(self._card(
            f"[color=#e63946][b]Error[/b][/color]\n{msg}\n\n"
            "[size=11]Make sure GlassFish is running\nand SmartGroceryInventory is deployed.[/size]",
            (0.9, 0.2, 0.2, 1)
        ))

    def _show_list(self, data):
        self.results.clear_widgets()
        try:
            items = json.loads(data)
            self.status_label.text = f"Loaded {len(items)} record(s)"
            self.status_label.color = (0.176, 0.416, 0.310, 1)
            if not items:
                self.results.add_widget(self._card("[i]No records found.[/i]"))
                return
            for item in items:
                self.results.add_widget(self._card(self.formatter(item)))
        except Exception:
            self._show_error("Invalid response from server")

    def _show_single(self, data):
        self.results.clear_widgets()
        try:
            item = json.loads(data)
            if 'error' in item:
                self.status_label.text = item['error']
                self.status_label.color = (0.9, 0.2, 0.2, 1)
                self.results.add_widget(self._card(
                    f"[color=#e63946]{item['error']}[/color]", (0.9, 0.2, 0.2, 1)
                ))
            else:
                self.status_label.text = "Record found"
                self.status_label.color = (0.176, 0.416, 0.310, 1)
                self.results.add_widget(self._card(self.formatter(item)))
        except Exception:
            self._show_error("Invalid response from server")

    def _show_count(self, data):
        self.results.clear_widgets()
        self.status_label.text = "Count retrieved"
        self.status_label.color = (0.176, 0.416, 0.310, 1)
        self.results.add_widget(self._card(
            f"[b][size=18]Total Records: {data}[/size][/b]", (0, 0.467, 0.714, 1)
        ))

    def _card(self, text, accent=(0.176, 0.416, 0.310, 1)):
        card = BoxLayout(orientation='vertical', size_hint_y=None, padding=[dp(14), dp(10)])
        with card.canvas.before:
            Color(*accent)
            card._accent = Rectangle()
            Color(1, 1, 1, 1)
            card._bg = Rectangle()

        def update(inst, val):
            inst._accent.pos = inst.pos
            inst._accent.size = (dp(4), inst.height)
            inst._bg.pos = (inst.x + dp(4), inst.y)
            inst._bg.size = (inst.width - dp(4), inst.height)
        card.bind(pos=update, size=update)

        lbl = Label(
            text=text, markup=True, font_size=dp(12),
            color=(0.2, 0.2, 0.2, 1), halign='left', valign='top',
            size_hint_y=None, text_size=(Window.width - dp(55), None)
        )
        lbl.bind(texture_size=lbl.setter('size'))
        card.add_widget(lbl)
        card.bind(minimum_height=card.setter('height'))
        return card


if __name__ == '__main__':
    SmartGroceryMobile().run()
