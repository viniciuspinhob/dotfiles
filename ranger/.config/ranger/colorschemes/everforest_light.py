from ranger.gui.color import *
from ranger.colorschemes.default import Default


class Scheme(Default):
    progress_bar_color = 106

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
                bg = 230
            if context.border:
                fg = 230
            if context.media:
                if context.image:
                    fg = 106
                else:
                    fg = 172
            if context.container:
                fg = 172
            if context.directory:
                if context.main_column:
                    fg = 178
                else:
                    fg = 31
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 106
            if context.socket:
                fg = 172
                attr |= bold
            if context.fifo:
                fg = 172
            if context.device:
                fg = 172
            if context.link:
                fg = 31 if context.good else 160
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 106
            if not context.selected and (context.cut or context.copied):
                fg = 230
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    if not context.directory:
                        fg = 106
            if context.badinfo:
                if attr & reverse:
                    bg = 160
                else:
                    fg = 160

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 106
            elif context.directory:
                fg = 31
            elif context.tab:
                if context.good:
                    bg = 106
            elif context.link:
                fg = 31

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 106
                elif context.bad:
                    fg = 160
            if context.marked:
                attr |= bold | reverse
                fg = 106
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 160
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 31
                attr &= ~bold
            if context.vcscommit:
                fg = 106
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 31
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
                fg = 160
            elif context.vcschanged:
                fg = 172
            elif context.vcsunknown:
                fg = 106
            elif context.vcsstaged:
                fg = 106
                attr |= bold
            elif context.vcssync:
                fg = 106
            elif context.vcsbehind:
                fg = 172
            elif context.vcsahead:
                fg = 31
            elif context.vcsdiverged:
                fg = 160
                attr |= bold
            elif context.vcsnone:
                fg = 244
            else:
                fg = 244

        return (fg, bg, attr)
