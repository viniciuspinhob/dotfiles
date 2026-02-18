from ranger.gui.color import *
from ranger.colorschemes.default import Default


class Scheme(Default):
    progress_bar_color = 142  # everforest green

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.reset:
            return (fg, bg, attr)

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = 236
            if context.border:
                fg = 236
            if context.media:
                if context.image:
                    fg = 142  # green
                else:
                    fg = 208  # orange
            if context.container:
                fg = 208  # orange
            if context.directory:
                if context.main_column:
                    fg = 214  # yellow
                else:
                    fg = 109  # blue
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 142  # green
            if context.socket:
                fg = 208  # orange
                attr |= bold
            if context.fifo:
                fg = 208  # orange
            if context.device:
                fg = 208  # orange
            if context.link:
                fg = 109 if context.good else 167  # blue or red
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 142  # green
            if not context.selected and (context.cut or context.copied):
                fg = 236
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    if not context.directory:
                        fg = 142  # green
            if context.badinfo:
                if attr & reverse:
                    bg = 167  # red
                else:
                    fg = 167  # red

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 142 if context.bad else 142  # green
            elif context.directory:
                fg = 109  # blue
            elif context.tab:
                if context.good:
                    bg = 142  # green
            elif context.link:
                fg = 109  # blue

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 142  # green
                elif context.bad:
                    fg = 167  # red
            if context.marked:
                attr |= bold | reverse
                fg = 142  # green
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 167  # red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 109  # blue
                attr &= ~bold
            if context.vcscommit:
                fg = 142  # green
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 109  # blue
            if context.selected:
                attr |= bold
            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 167  # red
            elif context.vcschanged:
                fg = 208  # orange
            elif context.vcsunknown:
                fg = 142  # green
            elif context.vcsstaged:
                fg = 142  # green
                attr |= bold
            elif context.vcssync:
                fg = 142  # green
            elif context.vcsbehind:
                fg = 208  # orange
            elif context.vcsahead:
                fg = 109  # blue
            elif context.vcsdiverged:
                fg = 167  # red
                attr |= bold
            elif context.vcsnone:
                fg = 245  # gray
            else:
                fg = 245  # gray

        return (fg, bg, attr)
