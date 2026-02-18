from ranger.gui.color import *
from ranger.colorschemes.default import Default


class Scheme(Default):
    progress_bar_color = 84

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
                    fg = 84
                else:
                    fg = 215
            if context.container:
                fg = 215
            if context.directory:
                if context.main_column:
                    fg = 141
                else:
                    fg = 117
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 84
            if context.socket:
                fg = 215
                attr |= bold
            if context.fifo:
                fg = 215
            if context.device:
                fg = 215
            if context.link:
                fg = 117 if context.good else 203
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 84
            if not context.selected and (context.cut or context.copied):
                fg = 236
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    if not context.directory:
                        fg = 84
            if context.badinfo:
                if attr & reverse:
                    bg = 203
                else:
                    fg = 203

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 84 if context.bad else 84
            elif context.directory:
                fg = 117
            elif context.tab:
                if context.good:
                    bg = 84
            elif context.link:
                fg = 117

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 84
                elif context.bad:
                    fg = 203
            if context.marked:
                attr |= bold | reverse
                fg = 84
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 203
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 117
                attr &= ~bold
            if context.vcscommit:
                fg = 84
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 117
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
                fg = 203
            elif context.vcschanged:
                fg = 215
            elif context.vcsunknown:
                fg = 84
            elif context.vcsstaged:
                fg = 84
                attr |= bold
            elif context.vcssync:
                fg = 84
            elif context.vcsbehind:
                fg = 215
            elif context.vcsahead:
                fg = 117
            elif context.vcsdiverged:
                fg = 203
                attr |= bold
            elif context.vcsnone:
                fg = 61
            else:
                fg = 61

        return (fg, bg, attr)
